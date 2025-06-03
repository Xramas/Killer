#!/bin/bash
# Name: 软件源自动配置（支持 Debian 11/12 + 区域判断）(Software source auto-configuration (supports Debian 11/12 + region detection))

# Source i18n
if [[ -n "$STR_AREA_NOT_DEFINED" ]]; then
    :
elif [[ -f "./i18n.sh" ]]; then
    source "./i18n.sh"
elif [[ -f "../i18n.sh" ]]; then
    source "../i18n.sh"
else
    echo "Warning: i18n.sh not found in sources.sh. Using fallback messages."
    STR_AREA_NOT_DEFINED="❌ AREA is not defined. Please run area.sh first."
    STR_CONFIGURING_APT_SOURCES="🔧 Configuring APT sources based on system version and region..."
    STR_USING_TSINGHUA_DEBIAN_11="Using Tsinghua mirror (Debian 11)"
    STR_USING_OFFICIAL_DEBIAN_11="Using official mirror (Debian 11)"
    STR_USING_TSINGHUA_DEBIAN_12="Using Tsinghua mirror (Debian 12)"
    STR_USING_OFFICIAL_DEBIAN_12="Using official mirror (Debian 12)"
    STR_UNSUPPORTED_DEBIAN_VERSION_PRE="❌ Unsupported Debian version: "
    STR_EXECUTING_APT_UPDATE="📦 Executing apt update..."
    STR_APT_SOURCES_CONFIG_DONE="✅ Software sources configured."
fi

# 获取系统版本号
OS_VERSION=$(lsb_release -r | awk '{print $2}') #

# 判断 AREA 是否已设置 (AREA is typically set by area.sh and sourced by start.sh)
if [[ -z "$AREA" ]]; then #
    echo "$STR_AREA_NOT_DEFINED" #
    exit 1
fi

echo "$STR_CONFIGURING_APT_SOURCES" #

# Debian 11
if [[ "$OS_VERSION" == "11" ]]; then #
    if [[ "$AREA" == "CN" ]]; then #
        echo "$STR_USING_TSINGHUA_DEBIAN_11" #
        cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bullseye-security main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
EOF
    else
        echo "$STR_USING_OFFICIAL_DEBIAN_11" #
        cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bullseye main contrib non-free
deb https://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb https://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb https://deb.debian.org/debian/ bullseye-backports main contrib non-free
EOF
    fi
# Debian 12
elif [[ "$OS_VERSION" == "12" ]]; then #
    if [[ "$AREA" == "CN" ]]; then #
        echo "$STR_USING_TSINGHUA_DEBIAN_12" #
        cat > /etc/apt/sources.list << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
EOF
    else
        echo "$STR_USING_OFFICIAL_DEBIAN_12" #
        cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb https://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware
EOF
    fi
else
    echo "${STR_UNSUPPORTED_DEBIAN_VERSION_PRE}$OS_VERSION" #
    exit 1
fi

echo "$STR_EXECUTING_APT_UPDATE" #
apt update -y #

echo "$STR_APT_SOURCES_CONFIG_DONE" # This string was added based on installer/01_configure_sources.sh, assuming similar completion message is desired.
                                 # Original sources.sh did not have a final completion message.
                                 # You can remove this line if no final message is needed from this script.
