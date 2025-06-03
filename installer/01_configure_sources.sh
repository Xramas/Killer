#!/bin/bash
# Name: 智能配置 Debian 软件源（按版本/IP 区分）

clear
echo ">>> 智能配置 Debian 软件源 <<<"
echo "正在检测系统版本与地理位置..."

# 获取系统版本和 IP 地址
OS_VERSION=$(lsb_release -r | awk '{print $2}')
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# 获取外网 IP 地址，以判断是否为中国大陆 IP
IS_CHINA_IP=$(curl -s https://ipinfo.io/$IP_ADDRESS | grep -i "China")

# 根据不同情况配置 sources.list
if [[ "$OS_VERSION" == "11" && "$IS_CHINA_IP" != "" ]]; then
    echo "🎯 检测到 Debian 11 + 中国大陆 IP，使用清华镜像源"
    cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main contrib non-free
EOF

elif [[ "$OS_VERSION" == "11" && "$IS_CHINA_IP" == "" ]]; then
    echo "🌐 Debian 11 + 非中国 IP，使用官方源"
    cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bullseye main contrib non-free
deb-src https://deb.debian.org/debian/ bullseye main contrib non-free

deb https://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src https://deb.debian.org/debian/ bullseye-updates main contrib non-free

deb https://deb.debian.org/debian/ bullseye-backports main contrib non-free
deb-src https://deb.debian.org/debian/ bullseye-backports main contrib non-free

deb https://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src https://deb.debian.org/debian-security/ bullseye-security main contrib non-free
EOF

elif [[ "$OS_VERSION" == "12" && "$IS_CHINA_IP" != "" ]]; then
    echo "🎯 检测到 Debian 12 + 中国大陆 IP，使用清华镜像源"
    cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware
EOF

elif [[ "$OS_VERSION" == "12" && "$IS_CHINA_IP" == "" ]]; then
    echo "🌐 Debian 12 + 非中国 IP，使用官方源"
    cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware

deb https://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
EOF

else
    echo "❌ 无法识别系统版本或 IP 来源，终止操作。"
    exit 1
fi

echo "📦 正在执行 apt update..."
apt update -y

echo "✅ 软件源配置完成。"
read -p "按回车键返回主菜单..." dummy
