#!/bin/bash

set -e

# 仓库基本信息
REPO="Xramas/Killer"
RAW_BASE_URL="https://raw.githubusercontent.com/$REPO/refs/heads/master"
GH_PROXY_BASE_URL="https://gh-proxy.com/https://raw.githubusercontent.com/$REPO/refs/heads/master"

# 工作路径
WORKDIR="/tmp/killer-tools"
mkdir -p "$WORKDIR"

# 核心脚本清单
CORE_SCRIPTS=("area.sh" "configure_sources.sh" "essential.sh" "function.sh" "killer_cleanup.sh")

# -----------------------------
# ① 初步网络判断（仅依赖 curl）
# -----------------------------
echo "🌐 正在初步检测网络区域..."

COUNTRY=$(curl -s https://ipinfo.io/country || echo "ERR")
if [[ "$COUNTRY" == "CN" ]]; then
    AREA="CN"
    BASE_URL="$GH_PROXY_BASE_URL"
    echo "🇨🇳 检测为中国大陆网络，使用加速链接"
else
    AREA="Other"
    BASE_URL="$RAW_BASE_URL"
    echo "🌍 检测为非中国大陆网络，使用 GitHub 原始链接"
fi

# -----------------------------
# ② 下载并引入清理器（先执行 trap）
# -----------------------------
CLEANER_URL="$BASE_URL/killer_cleanup.sh"
curl -sL "$CLEANER_URL" -o "$WORKDIR/killer_cleanup.sh"
chmod +x "$WORKDIR/killer_cleanup.sh"
source "$WORKDIR/killer_cleanup.sh"

# -----------------------------
# ③ 下载核心脚本
# -----------------------------
for file in "${CORE_SCRIPTS[@]}"; do
    [[ "$file" == "killer_cleanup.sh" ]] && continue  # 已下载
    echo "⏬ 正在下载 $file ..."
    curl -sL "$BASE_URL/$file" -o "$WORKDIR/$file" || {
        echo "❌ 下载 $file 失败，终止启动"
        exit 1
    }
    chmod +x "$WORKDIR/$file"
done

# -----------------------------
# ④ 执行初始化流程
# -----------------------------
cd "$WORKDIR"
source ./area.sh             # 设置 AREA=CN/Other
bash ./configure_sources.sh # 自动换源 + apt update
bash ./essential.sh         # 安装 unzip、curl、lsb_release 等

# -----------------------------
# ⑤ 下载并解压主程序
# -----------------------------
ZIPNAME="master.zip"
ZIPDIR="Killer-master"
RAW_ZIP_URL="https://github.com/$REPO/archive/refs/heads/$ZIPNAME"
GH_ZIP_URL="https://gh-proxy.com/github.com/$REPO/archive/refs/heads/$ZIPNAME"
ZIP_URL="$([[ "$AREA" == "CN" ]] && echo "$GH_ZIP_URL" || echo "$RAW_ZIP_URL")"

echo "📥 正在下载 Killer 主程序..."
curl -sL "$ZIP_URL" -o "$WORKDIR/$ZIPNAME"

echo "🧩 正在解压..."
unzip -q "$WORKDIR/$ZIPNAME" -d "$WORKDIR"

cd "$WORKDIR/$ZIPDIR" || {
    echo "❌ 解压失败，找不到主目录"
    exit 1
}

# -----------------------------
# ⑥ 启动主菜单
# -----------------------------
echo "🚀 启动 Killer Tools 主程序..."
bash ./function.sh
