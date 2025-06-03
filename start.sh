#!/bin/bash

# 临时工作目录
WORKDIR="/tmp/killer-tools"
REPO="Xramas/Killer"
ZIP_NAME="master.zip"
GITHUB_URL="https://github.com/$REPO/archive/refs/heads/$ZIP_NAME"
GH_PROXY_URL="https://gh-proxy.com/github.com/$REPO/archive/refs/heads/$ZIP_NAME"

# 判断网络位置（是否在中国大陆）
echo "🌐 正在检测网络环境..."
IPINFO=$(curl -s https://ipinfo.io/country)
if [[ "$IPINFO" == "CN" ]]; then
    echo "🇨🇳 检测到中国大陆网络，将使用加速下载..."
    DOWNLOAD_URL="$GH_PROXY_URL"
else
    echo "🌍 检测到非中国大陆网络，使用 GitHub 官方源..."
    DOWNLOAD_URL="$GITHUB_URL"
fi

# 清理旧数据
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

# 下载 ZIP 文件
echo "📦 正在从: $DOWNLOAD_URL 下载项目..."
curl -sL "$DOWNLOAD_URL" -o "$WORKDIR/$ZIP_NAME"

# 检查是否成功
if [[ ! -s "$WORKDIR/$ZIP_NAME" ]]; then
    echo "❌ 下载失败，请检查网络或稍后重试。"
    exit 1
fi

# 解压并进入目录
echo "🧩 正在解压..."
unzip -q "$WORKDIR/$ZIP_NAME" -d "$WORKDIR"
cd "$WORKDIR/Killer-master" || {
    echo "❌ 解压后未找到主目录！"
    exit 1
}

# 执行主程序
echo "🚀 启动 Killer Tools 主程序..."
bash function.sh
