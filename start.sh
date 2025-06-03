#!/bin/bash

set -e

# 加载清理逻辑
source "$WORKDIR/killer_cleanup.sh"

# 仓库基本信息
REPO="Xramas/Killer"
RAW_BASE_URL="https://raw.githubusercontent.com/$REPO/refs/heads/master"
GH_PROXY_BASE_URL="https://gh-proxy.com/https://raw.githubusercontent.com/$REPO/refs/heads/master"

# 工作路径
WORKDIR="/tmp/killer-tools"
mkdir -p "$WORKDIR"

# 优先脚本（依赖前置）
CORE_SCRIPTS=("area.sh" "configure_sources.sh" "essential.sh" "function.sh")

# -----------------------------
# ① 初步区域判断（仅依赖 curl）
# -----------------------------
echo "🌐 正在初步检测网络区域..."

IP_API=$(curl -s https://ipinfo.io/country || echo "Other")
if [[ "$IP_API" == "CN" ]]; then
    AREA="CN"
    BASE_URL="$GH_PROXY_BASE_URL"
    echo "🇨🇳 检测为中国大陆网络，使用加速链接"
else
    AREA="Other"
    BASE_URL="$RAW_BASE_URL"
    echo "🌍 检测为非中国大陆网络，使用 GitHub 原始链接"
fi

# -----------------------------
# ② 拉取核心脚本文件到临时目录
# -----------------------------
for file in "${CORE_SCRIPTS[@]}"; do
    echo "⏬ 正在下载 $file ..."
    curl -sL "$BASE_URL/$file" -o "$WORKDIR/$file" || {
        echo "❌ 下载 $file 失败，终止启动"
        exit 1
    }
    chmod +x "$WORKDIR/$file"
done

# -----------------------------
# ③ 执行核心逻辑
# -----------------------------
cd "$WORKDIR"

# 设置 AREA 并继续区域判断（area.sh 可做更多逻辑）
source ./area.sh

# 自动换源
bash ./configure_sources.sh

# 安装 curl、unzip、lsb_release 等基础工具
bash ./essential.sh

# -----------------------------
# ④ 下载主程序包
# -----------------------------
ZIPNAME="master.zip"
ZIPDIR="Killer-master"
RAW_ZIP_URL="https://github.com/$REPO/archive/refs/heads/$ZIPNAME"
GH_ZIP_URL="https://gh-proxy.com/github.com/$REPO/archive/refs/heads/$ZIPNAME"
ZIP_URL="$([[ "$AREA" == "CN" ]] && echo "$GH_ZIP_URL" || echo "$RAW_ZIP_URL")"

echo "📥 正在下载 Killer 工具箱主程序包..."
curl -sL "$ZIP_URL" -o "$WORKDIR/$ZIPNAME"

echo "🧩 正在解压..."
unzip -q "$WORKDIR/$ZIPNAME" -d "$WORKDIR"

cd "$WORKDIR/$ZIPDIR" || {
    echo "❌ 解压失败，找不到主目录"
    exit 1
}

# -----------------------------
# ⑤ 启动主菜单
# -----------------------------
echo "🚀 启动 Killer Tools 主程序..."
bash ./function.sh
