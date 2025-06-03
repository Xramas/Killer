#!/bin/bash
# Name: 软件源自动配置（支持 Debian 11/12 + 区域判断）

# 获取系统版本号
OS_VERSION=$(lsb_release -r | awk '{print $2}')

# 判断 AREA 是否已设置
if [[ -z "$AREA" ]]; then
    echo "❌ AREA 未定义，请先执行 area.sh"
    exit 1
fi

echo "🔧 正在根据系统版本和区域配置 APT 源..."

# Debian 11
if [[ "$OS_VERSION" == "11" ]]; then
    if [[ "$AREA" == "CN" ]]; then
        echo "使用清华源（Debian 11）"
        cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
EOF
    else
        echo "使用官方源（Debian 11）"
        cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bullseye main contrib non-free
deb https://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb https://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb https://deb.debian.org/debian/ bullseye-backports main contrib non-free
EOF
    fi
# Debian 12
elif [[ "$OS_VERSION" == "12" ]]; then
    if [[ "$AREA" == "CN" ]]; then
        echo "使用清华源（Debian 12）"
        cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
EOF
    else
        echo "使用官方源（Debian 12）"
        cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb https://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware
EOF
    fi
else
    echo "❌ 不支持的 Debian 版本：$OS_VERSION"
    exit 1
fi

echo "📦 正在执行 apt update..."
apt update -y
