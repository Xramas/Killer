#!/bin/bash
# Name: Killer 启动入口 (Killer Start Entry)

# Attempt to source i18n.sh early for initial messages.
# This assumes i18n.sh and locales/ might be downloaded or already present.
# If start.sh is run via curl, it won't have access to local i18n.sh initially.
# For messages *before* full project download, we might use a simpler approach or default to one language.

# For messages *after* project download and cd:
# BASE_DIR_START will be /tmp/killer-tools/Killer-master after cd
# Trap should ideally also use i18n string if defined by then.
# For now, trap message is simple.
trap "echo 'Performing cleanup...'; bash cleanup.sh all" EXIT

# Early messages (before full i18n is certainly available) - might remain in a default language or be very simple.
echo "🌐 Detecting network environment..." # This could be STR_DETECTING_NETWORK if i18n loaded

set -e
ts=$(date +%s)

# Download area.sh (its internal logic doesn't produce much user-facing text that needs i18n here)
curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/area.sh?${ts}" -o /tmp/area.sh
chmod +x /tmp/area.sh
source /tmp/area.sh # Exports AREA variable

# It's only after this point we can reliably source our full i18n.sh from the project files.
# The messages below will be internationalized once the project is downloaded and i18n.sh is sourced.

# --- PRE-DOWNLOAD MESSAGES (using default or simple text) ---
if [[ "$AREA" == "CN" ]]; then
    ZIP_URL="https://gh-proxy.com/github.com/Xramas/Killer/archive/refs/heads/master.zip"
    echo "🌏 Detected Mainland China network, using accelerated source..." # STR_DETECTED_MAINLAND_CHINA (pending load)
else
    ZIP_URL="https://github.com/Xramas/Killer/archive/refs/heads/master.zip"
    echo "🌍 Detected non-Mainland China network, using GitHub official source..." # STR_DETECTED_NON_MAINLAND_CHINA (pending load)
fi

echo "📥 Downloading initial essential scripts (these won't use i18n for their own output yet)..." # STR_DOWNLOADING_INIT_SCRIPTS (pending load)
# These scripts (sources.sh, essential.sh) will be replaced by versions from the zip later,
# which *will* have i18n. The temporary ones might not.
for file in sources.sh essential.sh; do # Removed function.sh, area.sh as they are handled differently or already sourced
    curl -sL "https://raw.githubusercontent.com/Xramas/Killer/master/$file?${ts}" -o "/tmp/$file"
    chmod +x "/tmp/$file"
done

# Download and unpack the full project
echo "📦 Downloading project from: $ZIP_URL ..." # STR_DOWNLOADING_PROJECT_FROM, STR_DOWNLOADING_PROJECT_SUFFIX (pending load)
wget -qO /tmp/killer.zip "$ZIP_URL"

echo "🧩 Extracting archive..." # STR_EXTRACTING_ARCHIVE (pending load)
rm -rf /tmp/killer-tools
mkdir -p /tmp/killer-tools
unzip -q /tmp/killer.zip -d /tmp/killer-tools

cd /tmp/killer-tools/Killer-master || {
    echo "❌ Main directory not found after extraction!" # STR_EXTRACT_FAILED_NO_MAIN_DIR (pending load, or hardcode if critical)
    exit 1
}

# --- POST-DOWNLOAD - FULL I18N CAN BE LOADED ---
# Now we are inside the project directory, so we can source the local i18n.sh
if [[ -f "./i18n.sh" ]]; then
    source "./i18n.sh"
else
    echo "Warning: ./i18n.sh not found after project extraction. Using fallback messages."
    # Define STR_ variables in English as a fallback if i18n.sh or lang files are missing
    STR_CHANGING_SOFTWARE_SOURCES="🔧 Changing software sources..."
    STR_INSTALLING_BASE_DEPENDENCIES="📦 Installing base dependencies..."
    STR_SETTING_PERMISSIONS="🔑 Setting script execution permissions..."
    STR_STARTING_KILLER="🚀 Starting Killer..."
    STR_EXTRACT_FAILED_NO_MAIN_DIR="❌ Main directory not found after extraction!" # For the earlier message
fi

# Now use the STR_ variables
echo "$STR_CHANGING_SOFTWARE_SOURCES"
# sources.sh is now the one from the ZIP, ensure IT sources i18n.sh
# The /tmp/sources.sh is temporary. The actual one is in ./sources.sh
if [[ -f "./sources.sh" ]]; then
    bash ./sources.sh # This script should source i18n.sh itself
else
    /tmp/sources.sh # Fallback to temp one if not in zip for some reason
fi


echo "$STR_INSTALLING_BASE_DEPENDENCIES"
# essential.sh is now the one from the ZIP
if [[ -f "./essential.sh" ]]; then
    bash ./essential.sh # This script should source i18n.sh itself
else
    /tmp/essential.sh
fi

echo "$STR_SETTING_PERMISSIONS"
find . -type f -name "*.sh" -exec chmod +x {} \;

# Start the main program (function.sh should source i18n.sh)
echo "$STR_STARTING_KILLER"
bash ./function.sh # function.sh will source its own i18n.sh
