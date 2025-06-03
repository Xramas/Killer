#!/bin/bash
# Name: Killer 启动入口

set -e

echo "🌐 正在检测网络环境..."

# 使用时间戳参数防缓存
ts=$(date +%s)

# 判断区域
curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/area.sh?${ts}" -o /tmp/area.sh
chmod +x /tmp/area.sh
source /tmp/area.sh

# 选择区域对应地址
if [[ "$AREA" == "CN" ]]; then
    ZIP_URL="https://gh-proxy.com/github.com/Xramas/Killer/archive/refs/heads/master.zip"
    echo "🌏 检测到中国大陆网络，使用加速源..."
else
    ZIP_URL="https://github.com/Xramas/Killer/archive/refs/heads/master.zip"
    echo "🌍 检测到非中国大陆网络，使用 GitHub 官方源..."
fi

# 下载初始化脚本
echo "📥 下载初始化脚本..."
for file in area.sh sources.sh essential.sh function.sh; do
    curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/$file?${ts}" -o "/tmp/$file"
    chmod +x "/tmp/$file"
done

# 更换软件源并更新
echo "🔧 正在更换软件源..."
/tmp/sources.sh

# 安装必要依赖 unzip、curl、bash 等
echo "📦 安装基础依赖..."
/tmp/essential.sh

# 下载并解压主程序
echo "📦 正在从: $ZIP_URL 下载项目..."
wget -qO /tmp/killer.zip "$ZIP_URL"

echo "🧩 正在解压..."
rm -rf /tmp/killer-tools
mkdir -p /tmp/killer-tools
unzip -q /tmp/killer.zip -d /tmp/killer-tools

cd /tmp/killer-tools/Killer-master || { echo "❌ 解压后未找到主目录！"; exit 1; }

# 设置执行权限
echo "🔑 正在设置脚本执行权限..."
find . -type f -name "*.sh" -exec chmod +x {} \;

# 启动 Killer
echo "🚀 启动 Killer..."
bash ./function.sh
