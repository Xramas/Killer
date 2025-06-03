#!/bin/bash
# 用法: bash requirements.sh /path/to/plugin.sh

# Source i18n
if [[ -n "$STR_PLUGIN_FILE_NOT_FOUND_PRE" ]]; then
    : 
elif [[ -f "./i18n.sh" ]]; then
    source "./i18n.sh"
elif [[ -f "../i18n.sh" ]]; then
    source "../i18n.sh"
else
    echo "Warning: i18n.sh not found in requirements.sh. Using fallback messages."
    STR_PLUGIN_FILE_NOT_FOUND_PRE="❌ Plugin file not found: "
    STR_CHECKING_DEPENDENCIES_FOR_PLUGIN="🔍 Checking dependencies: "
    STR_MISSING_DEPENDENCY_INSTALLING_PRE="📦 Missing dependency: "
    STR_MISSING_DEPENDENCY_INSTALLING_POST=", installing..."
    STR_DEPENDENCY_ALREADY_INSTALLED_POST=" already installed"
fi

PLUGIN_FILE="$1" #

if [[ ! -f "$PLUGIN_FILE" ]]; then #
    echo "${STR_PLUGIN_FILE_NOT_FOUND_PRE}$PLUGIN_FILE" #
    exit 1
fi

# 提取依赖声明行
REQUIRE_LINE=$(grep -E '^# ?Require:' "$PLUGIN_FILE") #
if [[ -z "$REQUIRE_LINE" ]]; then #
    exit 0  # 无依赖，跳过 (No dependencies, skip - this internal comment doesn't need i18n)
fi

# 解析依赖名
REQUIRES=$(echo "$REQUIRE_LINE" | cut -d':' -f2 | tr -s ' ') #

echo "$STR_CHECKING_DEPENDENCIES_FOR_PLUGIN $REQUIRES" #

for pkg in $REQUIRES; do #
    if ! command -v "$pkg" &>/dev/null; then #
        echo "${STR_MISSING_DEPENDENCY_INSTALLING_PRE}$pkg${STR_MISSING_DEPENDENCY_INSTALLING_POST}" #
        apt install -y "$pkg" #
    else
        echo "✅ $pkg$STR_DEPENDENCY_ALREADY_INSTALLED_POST" #
    fi
done
