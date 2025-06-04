#!/bin/bash
# Killer Toolkit - English Translations (locales/en.sh)

# General
STR_ERROR_PREFIX="Error:"
STR_WARNING_PREFIX="Warning:"
STR_INFO_PREFIX="Info:"
STR_PRESS_ENTER_TO_CONTINUE="Press Enter to continue..."
STR_PRESS_ENTER_TO_RETURN="Press Enter to return..."

# function.sh
STR_WELCOME_MESSAGE="🧠 Welcome to Killer Tools"
STR_MAIN_MENU_SEPARATOR="--------------------------"
STR_SYSINFO_MODULE="System Information Module"
STR_INSTALLER_MODULE="Software Installation Module"
STR_NETWORK_MODULE="Network Tools Module"
STR_OPTIMIZE_MODULE="Optimization & Cleanup Module"
STR_SECURITY_MODULE="Security Module"
STR_SERVICES_MODULE="Service Management Module"
STR_CUSTOM_MODULE="Custom Scripts Module"
STR_UNKNOWN_MODULE_PREFIX="Unknown Module"
STR_EXIT_OPTION="0) Exit"
STR_ENTER_MODULE_PROMPT="Enter module number and press Enter: "
STR_GOODBYE="👋 Goodbye!"
STR_INVALID_INPUT="❌ Invalid input, press Enter to retry..."
STR_MODULE_NO_PLUGINS_FOUND_PRE="⚠️  No plugins available in module \""
STR_MODULE_NO_PLUGINS_FOUND_POST="\", press Enter to return..."
STR_CURRENT_MODULE="📁 Current module: "
STR_UNNAMED_PLUGIN_PREFIX="Unnamed plugin ("
STR_UNNAMED_PLUGIN_SUFFIX=")"
STR_RETURN_TO_PREVIOUS="0) Return to previous menu"
STR_ENTER_FUNCTION_PROMPT="Enter function number and press Enter: "
STR_EXECUTING_PLUGIN="🔧 Executing plugin: "
STR_CHECKING_PLUGIN_DEPENDENCIES="⚙️  Checking and installing plugin dependencies..."
STR_DEPENDENCY_CHECK_COMPLETE="✅ Dependency check complete."
STR_REQUIREMENTS_SCRIPT_NOT_FOUND="⚠️  Warning: requirements.sh script not found, cannot check plugin dependencies."
STR_EXECUTING_PLUGIN_START="🚀 Starting plugin execution..."
STR_PLUGIN_EXECUTION_COMPLETE="✅ Plugin execution finished, press Enter to return to module menu..."

# start.sh
STR_DETECTING_NETWORK="🌐 Detecting network environment..."
STR_DETECTED_MAINLAND_CHINA="🌏 Detected Mainland China network, using accelerated source..."
STR_DETECTED_NON_MAINLAND_CHINA="🌍 Detected non-Mainland China network, using GitHub official source..."
STR_DOWNLOADING_INIT_SCRIPTS="📥 Downloading initialization scripts..."
STR_CHANGING_SOFTWARE_SOURCES="🔧 Changing software sources..."
STR_INSTALLING_BASE_DEPENDENCIES="📦 Installing base dependencies..."
STR_DOWNLOADING_PROJECT_FROM="📦 Downloading project from: "
STR_DOWNLOADING_PROJECT_SUFFIX=" ..."
STR_EXTRACTING_ARCHIVE="🧩 Extracting archive..."
STR_EXTRACT_FAILED_NO_MAIN_DIR="❌ Main directory not found after extraction!"
STR_SETTING_PERMISSIONS="🔑 Setting script execution permissions..."
STR_STARTING_KILLER="🚀 Starting Killer..."

# essential.sh (curl, wget, unzip, lsb-release)
STR_CHECKING_ESSENTIAL_DEPENDENCIES="🔍 Checking and installing essential dependencies..."
STR_INSTALLING_PKG="📦 Installing: "
STR_PKG_ALREADY_EXISTS="✅ Already exists: "
STR_ESSENTIAL_DEPENDENCIES_INSTALLED="✅ Essential dependencies installation complete."

# requirements.sh
STR_PLUGIN_FILE_NOT_FOUND_PRE="❌ Plugin file not found: "
STR_CHECKING_DEPENDENCIES_FOR_PLUGIN="🔍 Checking dependencies: "
STR_MISSING_DEPENDENCY_INSTALLING_PRE="📦 Missing dependency: "
STR_MISSING_DEPENDENCY_INSTALLING_POST=", installing..."
STR_DEPENDENCY_ALREADY_INSTALLED_POST=" already installed"

# sources.sh
STR_AREA_NOT_DEFINED="❌ AREA is not defined. Please run area.sh first."
STR_CONFIGURING_APT_SOURCES="🔧 Configuring APT sources based on system version and region..."
STR_USING_TSINGHUA_DEBIAN_11="Using Tsinghua mirror (Debian 11)"
STR_USING_OFFICIAL_DEBIAN_11="Using official mirror (Debian 11)"
STR_USING_TSINGHUA_DEBIAN_12="Using Tsinghua mirror (Debian 12)"
STR_USING_OFFICIAL_DEBIAN_12="Using official mirror (Debian 12)"
STR_UNSUPPORTED_DEBIAN_VERSION_PRE="❌ Unsupported Debian version: "
STR_EXECUTING_APT_UPDATE="📦 Executing apt update..."
STR_APT_SOURCES_CONFIG_DONE="✅ Software sources configured."

# installer/01_configure_sources.sh
STR_INSTALLER_CONFIGURE_SOURCES_TITLE=">>> Smart Configuration for Debian Software Sources <<<"
STR_INSTALLER_DETECTING_SYSTEM_GEO="Detecting system version and geographic location..."
STR_INSTALLER_DEBIAN11_CN_MSG="🎯 Detected Debian 11 + Mainland China IP, using Tsinghua mirror"
STR_INSTALLER_DEBIAN11_OTHER_MSG="🌐 Debian 11 + non-China IP, using official sources"
STR_INSTALLER_DEBIAN12_CN_MSG="🎯 Detected Debian 12 + Mainland China IP, using Tsinghua mirror"
STR_INSTALLER_DEBIAN12_OTHER_MSG="🌐 Debian 12 + non-China IP, using official sources"
STR_INSTALLER_CANNOT_IDENTIFY_SYSTEM="❌ Cannot identify system version or IP origin. Aborting operation."

# network/01_speedtest.sh
STR_NETWORK_SPEEDTEST_START="Starting speed test..."

# security/01_cloudflare_ufw.sh
STR_SECURITY_CF_SYNC_UFW_TITLE="🌐 Syncing Cloudflare IPs to UFW..."
STR_SECURITY_UFW_NOT_DETECTED_INSTALLING="📦 ufw not detected, installing..."
STR_SECURITY_ALLOW_SSH_PORT_PRE="Allowing SSH port "
STR_SECURITY_ALLOW_SSH_PORT_POST="/tcp for login"
STR_SECURITY_CF_RULES_SYNCED_UFW_ENABLED="✅ Cloudflare restriction rules synced and UFW enabled."

# sysinfo/01_basic.sh
STR_SYSINFO_BASIC_TITLE="🖥️  Basic System Information"
STR_SYSINFO_SEPARATOR="-----------------------------"
STR_SYSINFO_DISTRO_VERSION="📦  Distribution : "
STR_SYSINFO_KERNEL_VERSION="🧬  Kernel Version : "
STR_SYSINFO_ARCHITECTURE="🏗️  Architecture : "
STR_SYSINFO_HOSTNAME="💻  Hostname : "
STR_SYSINFO_LOCAL_IP="🌐  Local IP   : "
STR_SYSINFO_UPTIME="⏱️  Uptime     : "
STR_SYSINFO_CURRENT_USER="👥  Current User : "
STR_SYSINFO_MEMORY_USAGE="🧠  Memory Usage :"
STR_SYSINFO_DISK_USAGE="💽  Disk Usage   :"
STR_SYSINFO_DISPLAY_COMPLETE="✅ System information display complete."
