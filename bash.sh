#!/bin/bash

# 获取系统版本和 IP 地址
OS_VERSION=$(lsb_release -r | awk '{print $2}')
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# 获取外网 IP 地址，以判断是否为中国大陆 IP
IS_CHINA_IP=$(curl -s https://ipinfo.io/$IP_ADDRESS | grep -i "China")

# 根据不同情况配置 sources.list
if [[ "$OS_VERSION" == "11" && "$IS_CHINA_IP" != "" ]]; then
    # Debian 11 和中国大陆 IP
    echo "正在使用中国大陆的 Debian 11 源..."
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
    # Debian 11 和非中国大陆 IP
    echo "正在使用非中国大陆的 Debian 11 源..."
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
    # Debian 12 和中国大陆 IP
    echo "正在使用中国大陆的 Debian 12 源..."
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
    # Debian 12 和非中国大陆 IP
    echo "正在使用非中国大陆的 Debian 12 源..."
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
    # 系统版本和 IP 地址不符合要求
    echo "系统版本或 IP 地址不符合要求，无法配置 sources.list"
    exit 1
fi

# 执行 apt update 命令
apt update -y

# 清屏，进入交互式菜单
clear

# 显示欢迎信息和工具菜单
echo "初始化完成"
echo "欢迎使用 Killer Tools!"
echo "----------------------------"

# 交互式菜单
PS3="请选择一个操作 (输入数字并按回车): "
select option in "功能1" "功能2" "功能3" "退出"; do
    case $option in
        "功能1")
            echo "你选择了功能1"
            # 在这里添加功能1的实现
            break
            ;;
        "功能2")
            echo "你选择了功能2"
            # 在这里添加功能2的实现
            break
            ;;
        "功能3")
            echo "你选择了功能3"
            # 在这里添加功能3的实现
            break
            ;;
        "退出")
            echo "退出工具箱"
            break
            ;;
        *)
            echo "无效选项，请重新选择"
            ;;
    esac
done
