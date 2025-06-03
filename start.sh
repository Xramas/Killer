#!/bin/bash
# Name: Killer 安装脚本 (Killer Installation Script)

# --- 基本设置和清理 ---
# 目标安装路径
INSTALL_DIR="/usr/local/bin/killer"
# 主程序在PATH中的名称
LAUNCH_COMMAND_NAME="killer"

# 启动时绑定清理操作（仅清理下载和解压相关的临时文件）
trap "echo '执行临时文件清理...'; rm -f /tmp/killer.zip; rm -rf /tmp/killer-tools; rm -f /tmp/area.sh /tmp/sources.sh /tmp/essential.sh" EXIT

echo "🚀 Killer 工具箱安装程序"
echo "----------------------------------"
echo "ℹ️  安装目标目录: $INSTALL_DIR"
echo "ℹ️  安装后可用命令: $LAUNCH_COMMAND_NAME"
echo "----------------------------------"

# --- 权限检查 ---
if [[ $EUID -ne 0 ]]; then
   echo "❌ 错误: 此脚本需要 root 权限才能将文件安装到 $INSTALL_DIR 并创建符号链接。"
   echo "请尝试使用 'sudo bash $0' 来运行。"
   exit 1
fi

# --- 网络环境检测 ---
echo "🌐 正在检测网络环境..."
ts=$(date +%s)
# 下载并执行区域判断
curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/area.sh?${ts}" -o /tmp/area.sh #
chmod +x /tmp/area.sh #
source /tmp/area.sh #

if [[ "$AREA" == "CN" ]]; then #
    ZIP_URL="https://gh-proxy.com/github.com/Xramas/Killer/archive/refs/heads/master.zip" #
    echo "🌏 检测到中国大陆网络，使用加速源..." #
else
    ZIP_URL="https://github.com/Xramas/Killer/archive/refs/heads/master.zip" #
    echo "🌍 检测到非中国大陆网络，使用 GitHub 官方源..." #
fi

# --- 下载项目 ---
echo "📦 正在从: $ZIP_URL 下载项目..." #
wget -qO /tmp/killer.zip "$ZIP_URL" #
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 下载项目失败。请检查网络或 URL。"
    exit 1
fi

# --- 解压项目 ---
echo "🧩 正在解压到临时目录..." #
rm -rf /tmp/killer-tools #
mkdir -p /tmp/killer-tools #
unzip -q /tmp/killer.zip -d /tmp/killer-tools #
if [[ $? -ne 0 || ! -d "/tmp/killer-tools/Killer-master" ]]; then
    echo "❌ 错误: 解压项目失败或未找到 Killer-master 目录。" #
    exit 1
fi
PROJECT_TEMP_DIR="/tmp/killer-tools/Killer-master"

# --- 安装过程 ---
echo "🔧 准备安装 Killer 工具箱到 $INSTALL_DIR..."

# 1. 创建安装目录
echo "  ➡️ 创建安装目录: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 创建目录 $INSTALL_DIR 失败。"
    exit 1
fi

# 2. 复制文件
echo "  ➡️ 复制项目文件到 $INSTALL_DIR"
cp -r "$PROJECT_TEMP_DIR"/* "$INSTALL_DIR/"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 复制文件到 $INSTALL_DIR 失败。"
    exit 1
fi

# 3. 设置权限
echo "  ➡️ 设置脚本执行权限..." #
find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \; #
# 确保主入口脚本(如果将来创建单独的，如 "killer")也有执行权限
if [ -f "$INSTALL_DIR/function.sh" ]; then # 假设 function.sh 是主菜单脚本
    chmod +x "$INSTALL_DIR/function.sh"
fi
# 如果您决定创建一个新的顶级 `killer` 启动脚本放在 `$INSTALL_DIR/killer`
# chmod +x "$INSTALL_DIR/killer"

# 4. 创建主启动脚本的符号链接 (或包装脚本)
# 我们将创建一个简单的包装脚本作为主入口，并链接它
WRAPPER_SCRIPT_PATH="$INSTALL_DIR/$LAUNCH_COMMAND_NAME"
echo "  ➡️ 创建启动包装脚本: $WRAPPER_SCRIPT_PATH"
cat > "$WRAPPER_SCRIPT_PATH" << EOF
#!/bin/bash
# Killer Toolkit Launcher
# This script ensures that Killer is run from its installation directory.

# Change to the script's own directory (which is $INSTALL_DIR)
cd "$INSTALL_DIR"

# Execute the main function script, passing all arguments
bash ./function.sh "\$@"
EOF
chmod +x "$WRAPPER_SCRIPT_PATH"

# 5. 将包装脚本链接到 /usr/local/bin (使其在 PATH 中)
LAUNCH_LINK_PATH="/usr/local/bin/$LAUNCH_COMMAND_NAME"
echo "  ➡️ 创建符号链接: $LAUNCH_LINK_PATH -> $WRAPPER_SCRIPT_PATH"
# 删除可能存在的旧链接
if [ -L "$LAUNCH_LINK_PATH" ] || [ -f "$LAUNCH_LINK_PATH" ]; then
    rm -f "$LAUNCH_LINK_PATH"
fi
ln -s "$WRAPPER_SCRIPT_PATH" "$LAUNCH_LINK_PATH"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 创建符号链接 $LAUNCH_LINK_PATH 失败。"
    exit 1
fi

# --- 安装后操作 ---
# 运行必要的初始化脚本 (例如 sources.sh, essential.sh)
# 这些脚本现在应该从安装目录运行，并且内部路径引用要正确
echo "⚙️ 执行首次配置..."
# 更换软件源 (如果需要，可以提示用户是否执行)
echo "  ➡️ 配置软件源 (sources.sh)..."
if [ -f "$INSTALL_DIR/sources.sh" ]; then
    # sources.sh 内部需要能正确处理 AREA 变量
    # AREA 变量由 /tmp/area.sh 设置并 source 过，当前 shell 环境中应该还存在
    bash "$INSTALL_DIR/sources.sh" #
else
    echo "⚠️  警告: $INSTALL_DIR/sources.sh 未找到，跳过软件源配置。"
fi

# 安装基础依赖 (如果需要，可以提示用户是否执行)
echo "  ➡️ 安装基础依赖 (essential.sh)..."
if [ -f "$INSTALL_DIR/essential.sh" ]; then
    bash "$INSTALL_DIR/essential.sh" #
else
    echo "⚠️  警告: $INSTALL_DIR/essential.sh 未找到，跳过基础依赖安装。"
fi


echo "✅ Killer 工具箱成功安装！"
echo "现在您可以使用命令 '$LAUNCH_COMMAND_NAME' 来启动程序。"
echo "💡 提示: 您可能需要重新打开一个新的终端才能使 '$LAUNCH_COMMAND_NAME' 命令立即生效 (因为 PATH 的更新)。"

# 退出前清理临时文件由 trap 处理

exit 0
