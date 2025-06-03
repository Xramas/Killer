#!/bin/bash
# Name: 安装基础依赖 (Install essential dependencies)

# Source i18n (assuming this script is run from project root, or i18n.sh is found)
if [[ -n "$STR_CHECKING_ESSENTIAL_DEPENDENCIES" ]]; then # Check if i18n already loaded by a parent script
    : # Already loaded
elif [[ -f "./i18n.sh" ]]; then # Current dir is project root
    source "./i18n.sh"
elif [[ -f "../i18n.sh" ]]; then # Script is one level deep (not the case here, but good for plugins)
    source "../i18n.sh"
else
    # Fallback definitions if i18n.sh was not found
    echo "Warning: i18n.sh not found in essential.sh. Using fallback messages."
    STR_CHECKING_ESSENTIAL_DEPENDENCIES="🔍 Checking and installing essential dependencies..."
    STR_INSTALLING_PKG="📦 Installing: "
    STR_PKG_ALREADY_EXISTS="✅ Already exists: "
    STR_ESSENTIAL_DEPENDENCIES_INSTALLED="✅ Essential dependencies installation complete."
fi


ESSENTIALS=(curl unzip lsb-release) #

echo "$STR_CHECKING_ESSENTIAL_DEPENDENCIES" #
apt update -y  # Output from apt will be system locale

for pkg in "${ESSENTIALS[@]}"; do #
    if ! command -v "$pkg" >/dev/null 2>&1; then #
        echo "$STR_INSTALLING_PKG $pkg" #
        apt install -y "$pkg" # Output from apt will be system locale #
    else
        echo "$STR_PKG_ALREADY_EXISTS $pkg" #
    fi
done

echo "$STR_ESSENTIAL_DEPENDENCIES_INSTALLED" #
