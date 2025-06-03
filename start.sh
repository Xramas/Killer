#!/bin/bash
# Name: Killer 安装脚本 (Killer Installation Script)

# --- 基本设置和清理 ---
# 目标安装路径 (程序文件实际存放位置)
INSTALL_DIR="/usr/local/lib/killer"
# 主程序在PATH中的名称 (用户调用的命令)
LAUNCH_COMMAND_NAME="killer"
# 包装/启动脚本的完整路径 (在INSTALL_DIR中)
WRAPPER_SCRIPT_PATH="$INSTALL_DIR/$LAUNCH_COMMAND_NAME"
# 符号链接的完整路径 (在/usr/local/bin中，指向WRAPPER_SCRIPT_PATH)
LAUNCH_LINK_PATH="/usr/local/bin/$LAUNCH_COMMAND_NAME"

# 启动时绑定清理操作（仅清理下载和解压相关的临时文件）
trap "echo '执行临时文件清理...'; rm -f /tmp/killer.zip; rm -rf /tmp/killer-tools; rm -f /tmp/area.sh /tmp/sources.sh /tmp/essential.sh" EXIT

echo "🚀 Killer 工具箱安装程序"
echo "----------------------------------"
echo "ℹ️  安装目标目录: $INSTALL_DIR"
echo "ℹ️  程序启动脚本: $WRAPPER_SCRIPT_PATH"
echo "ℹ️  创建符号链接: $LAUNCH_LINK_PATH -> $WRAPPER_SCRIPT_PATH"
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
#
curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/area.sh?${ts}" -o /tmp/area.sh
#
chmod +x /tmp/area.sh
#
source /tmp/area.sh # Exports AREA variable

#
if [[ "$AREA" == "CN" ]]; then
    #
    ZIP_URL="https://gh-proxy.com/github.com/Xramas/Killer/archive/refs/heads/master.zip"
    #
    echo "🌏 检测到中国大陆网络，使用加速源..."
else
    #
    ZIP_URL="https://github.com/Xramas/Killer/archive/refs/heads/master.zip"
    #
    echo "🌍 检测到非中国大陆网络，使用 GitHub 官方源..."
fi

# --- 下载项目 ---
#
echo "📦 正在从: $ZIP_URL 下载项目..."
#
wget -qO /tmp/killer.zip "$ZIP_URL"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 下载项目失败。请检查网络或 URL。"
    exit 1
fi

# --- 解压项目 ---
#
echo "🧩 正在解压到临时目录..."
#
rm -rf /tmp/killer-tools
#
mkdir -p /tmp/killer-tools
#
unzip -q /tmp/killer.zip -d /tmp/killer-tools
#
if [[ $? -ne 0 || ! -d "/tmp/killer-tools/Killer-master" ]]; then
    echo "❌ 错误: 解压项目失败或未找到 Killer-master 目录。"
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
# 先清空目标目录，以防是更新操作
if [ "$(ls -A $INSTALL_DIR)" ]; then
   echo "  ⚠️  警告: 安装目录 $INSTALL_DIR 非空，将清空后继续..."
   rm -rf "${INSTALL_DIR:?}"/* # 加强保护，防止误删根目录等
   mkdir -p "$INSTALL_DIR" # 清空后重新创建，确保目录存在
fi
cp -r "$PROJECT_TEMP_DIR"/* "$INSTALL_DIR/"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 复制文件到 $INSTALL_DIR 失败。"
    exit 1
fi

# 3. 设置权限
#
echo "  ➡️ 设置脚本执行权限..."
#
find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;
# 确保主菜单脚本有执行权限
if [ -f "$INSTALL_DIR/function.sh" ]; then
    chmod +x "$INSTALL_DIR/function.sh"
fi


# 4. 创建主启动包装脚本 (在 INSTALL_DIR 中)
echo "  ➡️ 创建启动包装脚本: $WRAPPER_SCRIPT_PATH"
cat > "$WRAPPER_SCRIPT_PATH" << EOF
#!/bin/bash
# Killer Toolkit Launcher
# This script ensures that Killer is run from its installation directory.

# Change to the script's own installation directory
cd "$INSTALL_DIR"

# Execute the main function script, passing all arguments
# Assuming function.sh is the main menu script
bash ./function.sh "\$@"
EOF
chmod +x "$WRAPPER_SCRIPT_PATH"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 创建或设置包装脚本 $WRAPPER_SCRIPT_PATH 权限失败。"
    exit 1
fi

# 5. 将包装脚本链接到 /usr/local/bin (使其在 PATH 中)
echo "  ➡️ 创建符号链接: $LAUNCH_LINK_PATH -> $WRAPPER_SCRIPT_PATH"
# 删除可能存在的旧链接或同名文件/目录，以避免冲突
if [ -L "$LAUNCH_LINK_PATH" ] || [ -f "$LAUNCH_LINK_PATH" ] || [ -d "$LAUNCH_LINK_PATH" ]; then
    echo "  ℹ️  正在删除已存在的 $LAUNCH_LINK_PATH..."
    rm -rf "$LAUNCH_LINK_PATH"
fi
ln -s "$WRAPPER_SCRIPT_PATH" "$LAUNCH_LINK_PATH"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 创建符号链接 $LAUNCH_LINK_PATH 失败。"
    exit 1
fi

# --- 安装后操作 (可选，根据需要启用或提示用户) ---
echo "⚙️ 执行首次配置..."
# 更换软件源 (sources.sh)
echo "  ➡️ 正在准备配置软件源 (sources.sh)..."
if [ -f "$INSTALL_DIR/sources.sh" ]; then
    # AREA 变量由 /tmp/area.sh 设置并 source 过，当前 shell 环境中应该还存在
    # sources.sh 内部应能正确处理此变量
    # 同时，sources.sh 内部的 i18n.sh 引用，因为包装脚本会 cd 到 INSTALL_DIR，
    # 所以 sources.sh 中的 source ./i18n.sh 应该能工作
    read -p "❓ 是否现在自动配置软件源 (Debian 11/12)？ (y/N): " yn_sources
    if [[ "$yn_sources" =~ ^[Yy]$ ]]; then
        echo "  执行 $INSTALL_DIR/sources.sh ..."
        bash "$INSTALL_DIR/sources.sh"
    else
        echo "  跳过软件源配置。"
    fi
else
    echo "⚠️  警告: $INSTALL_DIR/sources.sh 未找到，跳过软件源配置。"
fi

# 安装基础依赖 (essential.sh)
echo "  ➡️ 正在准备安装基础依赖 (essential.sh)..."
if [ -f "$INSTALL_DIR/essential.sh" ]; then
    # essential.sh 内部的 i18n.sh 引用，同样因为包装脚本会 cd 到 INSTALL_DIR，
    # 所以 essential.sh 中的 source ./i18n.sh 应该能工作
    read -p "❓ 是否现在安装基础依赖 (curl, unzip, lsb-release)？ (y/N): " yn_essential
    if [[ "$yn_essential" =~ ^[Yy]$ ]]; then
        echo "  执行 $INSTALL_DIR/essential.sh ..."
        bash "$INSTALL_DIR/essential.sh"
    else
        echo "  跳过基础依赖安装。"
    fi
else
    echo "⚠️  警告: $INSTALL_DIR/essential.sh 未找到，跳过基础依赖安装。"
fi


echo "✅ Killer 工具箱成功安装！"
echo "----------------------------------"
echo "➡️  程序已安装到: $INSTALL_DIR"
echo "➡️  启动脚本位于: $WRAPPER_SCRIPT_PATH"
echo "➡️  您可以使用以下命令来启动程序:"
echo ""
echo "    $LAUNCH_COMMAND_NAME"
echo ""
echo "💡 提示: 如果命令无效，您可能需要重新打开一个新的终端，或执行 'source ~/.bashrc' (或类似命令，取决于您的 shell) 来使 PATH 的更新生效。"
echo "----------------------------------"

# 退出前清理临时文件由 trap 处理

exit 0
