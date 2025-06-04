#!/bin/bash
# Name: Killer 安装脚本 (Killer Installation Script)

# --- 基本设置和清理 ---
INSTALL_DIR="/usr/local/lib/killer"
LAUNCH_COMMAND_NAME="killer"
WRAPPER_SCRIPT_PATH="$INSTALL_DIR/$LAUNCH_COMMAND_NAME"
LAUNCH_LINK_PATH="/usr/local/bin/$LAUNCH_COMMAND_NAME"

# 启动时绑定清理操作（清理下载的zip和临时的area.sh）
trap "echo '执行临时文件清理...'; rm -f /tmp/killer.zip; rm -f /tmp/area.sh" EXIT # 注意，不再有 /tmp/killer-tools

echo "🚀 Killer 工具箱安装程序"
# ... (其他信息输出不变) ...

# --- 权限检查 ---
if [[ $EUID -ne 0 ]]; then
   echo "❌ 错误: 此脚本需要 root 权限才能将文件安装到 $INSTALL_DIR 并创建符号链接。"
   echo "请尝试使用 'sudo bash $0' 来运行。"
   exit 1
fi

# --- 早期依赖检查 (curl, wget, unzip) ---
echo "⚙️ 检查核心工具..."
for tool in curl wget unzip; do
    if ! command -v "$tool" &> /dev/null; then
        echo "❌ 错误: '$tool' 命令未找到。请先安装 $tool。"
        # 考虑是否添加自动安装逻辑，但这会增加复杂性
        # read -p "❓ 是否尝试自动安装 $tool (需要 apt)？ (y/N): " yn_tool
        # if [[ "$yn_tool" =~ ^[Yy]$ ]]; then
        #     apt update -y && apt install -y "$tool"
        #     if ! command -v "$tool" &> /dev/null; then exit 1; fi
        # else
        #     exit 1
        # fi
        exit 1
    fi
done

# --- 网络环境检测 ---
echo "🌐 正在检测网络环境..."
ts=$(date +%s)
# 下载并执行区域判断 (仍然使用 /tmp)
#
if ! curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/area.sh?${ts}" -o /tmp/area.sh; then
    echo "❌ 错误: 下载 area.sh 失败。"
    exit 1
fi

# 校验下载的脚本完整性（基于当前仓库中的 area.sh 哈希）
EXPECTED_SHA="8e6a3c28cc0a7580f4bf4f0e0e83c341d29c45468b92b3bfbf4d73f6890d445d"
DOWNLOADED_SHA=$(sha256sum /tmp/area.sh | awk '{print $1}')
if [[ "$DOWNLOADED_SHA" != "$EXPECTED_SHA" ]]; then
    echo "❌ 错误: area.sh 校验失败，可能已被篡改。"
    rm -f /tmp/area.sh
    exit 1
fi

chmod +x /tmp/area.sh
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

# --- 准备安装目录 ---
echo "🔧 准备安装目录 $INSTALL_DIR..."
# 先确保安装目录存在且清空 (如果是更新操作)
if [ -d "$INSTALL_DIR" ]; then
   echo "  ⚠️  警告: 安装目录 $INSTALL_DIR 已存在，将清空后继续..."
   # 使用 find 删除目录内容，比 rm -rf更安全一点，或者直接 rm -rf "$INSTALL_DIR"/*
   find "$INSTALL_DIR" -mindepth 1 -delete # 删除目录下的所有文件和子目录，但不删除INSTALL_DIR本身
   # 如果上面的find命令有问题或不够彻底，可以用 rm -rf "${INSTALL_DIR:?}"/*
else
    mkdir -p "$INSTALL_DIR"
    if [[ $? -ne 0 ]]; then
        echo "❌ 错误: 创建目录 $INSTALL_DIR 失败。"
        exit 1
    fi
fi

# --- 下载项目 (到 /tmp) ---
#
echo "📦 正在从: $ZIP_URL 下载项目到 /tmp/killer.zip..."
#
if ! wget -qO /tmp/killer.zip "$ZIP_URL"; then
    echo "❌ 错误: 下载项目失败。请检查网络或 URL。"
    exit 1
fi

# --- 解压项目直接到安装目录 ---
echo "🧩 正在解压 /tmp/killer.zip 到 $INSTALL_DIR..."
# GitHub的zip解压后会有一个顶层目录，如 Killer-master
# 我们需要将这个顶层目录的内容移动到 $INSTALL_DIR 的根下
# 先创建一个临时解压子目录，防止直接污染 $INSTALL_DIR
TEMP_UNZIP_SUBDIR="$INSTALL_DIR/_temp_unzip_killer"
mkdir -p "$TEMP_UNZIP_SUBDIR"

if ! unzip -q /tmp/killer.zip -d "$TEMP_UNZIP_SUBDIR"; then
    echo "❌ 错误: 解压项目到 $TEMP_UNZIP_SUBDIR 失败。"
    rm -rf "$TEMP_UNZIP_SUBDIR" # 清理临时解压子目录
    exit 1
fi

# 找到解压后的顶层目录名 (通常是 Killer-master)
# ls -d */ 会列出目录，我们取第一个
EXTRACTED_TOP_DIR_NAME=$(ls -d "$TEMP_UNZIP_SUBDIR"/*/ | head -n 1 | xargs basename)

if [ -z "$EXTRACTED_TOP_DIR_NAME" ] || [ ! -d "$TEMP_UNZIP_SUBDIR/$EXTRACTED_TOP_DIR_NAME" ]; then
    echo "❌ 错误: 未能在 $TEMP_UNZIP_SUBDIR 中找到预期的解压后顶层目录。"
    rm -rf "$TEMP_UNZIP_SUBDIR"
    exit 1
fi

# 将顶层目录的内容移动到 $INSTALL_DIR
echo "  ➡️ 正在整理文件到 $INSTALL_DIR..."
# 使用 shopt -s dotglob 来包含隐藏文件 (如 .gitignore)
shopt -s dotglob
mv "$TEMP_UNZIP_SUBDIR/$EXTRACTED_TOP_DIR_NAME"/* "$INSTALL_DIR/"
shopt -u dotglob # 恢复默认行为

# 清理临时解压子目录和空的顶层目录
rm -rf "$TEMP_UNZIP_SUBDIR"


# --- 文件已在 $INSTALL_DIR，继续后续步骤 ---

# 3. 设置权限
#
echo "  ➡️ 设置 $INSTALL_DIR 中的脚本执行权限..."
#
find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;
if [ -f "$INSTALL_DIR/function.sh" ]; then #
    chmod +x "$INSTALL_DIR/function.sh"
fi

# 4. 创建主启动包装脚本 (在 INSTALL_DIR 中)
echo "  ➡️ 创建启动包装脚本: $WRAPPER_SCRIPT_PATH"
cat > "$WRAPPER_SCRIPT_PATH" << EOF
#!/bin/bash
# Killer Toolkit Launcher
cd "$INSTALL_DIR"
bash ./function.sh "\$@"
EOF
chmod +x "$WRAPPER_SCRIPT_PATH"
if [[ $? -ne 0 ]]; then
    echo "❌ 错误: 创建或设置包装脚本 $WRAPPER_SCRIPT_PATH 权限失败。"
    exit 1
fi

# 5. 将包装脚本链接到 /usr/local/bin (使其在 PATH 中)
echo "  ➡️ 创建符号链接: $LAUNCH_LINK_PATH -> $WRAPPER_SCRIPT_PATH"
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
# ... (这部分与上一版相同，会提示用户是否执行 sources.sh 和 essential.sh) ...
echo "⚙️ 执行首次配置..."
# 更换软件源 (sources.sh)
echo "  ➡️ 正在准备配置软件源 (sources.sh)..."
if [ -f "$INSTALL_DIR/sources.sh" ]; then #
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
if [ -f "$INSTALL_DIR/essential.sh" ]; then #
    read -p "❓ 是否现在安装基础依赖 (curl, wget, unzip, lsb-release)？ (y/N): " yn_essential
    if [[ "$yn_essential" =~ ^[Yy]$ ]]; then
        echo "  执行 $INSTALL_DIR/essential.sh ..."
        bash "$INSTALL_DIR/essential.sh"
    else
        echo "  跳过基础依赖安装。"
    fi
else
    echo "⚠️  警告: $INSTALL_DIR/essential.sh 未找到，跳过基础依赖安装。"
fi

# ... (成功提示信息与上一版相同) ...
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

exit 0
