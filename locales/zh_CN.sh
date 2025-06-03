#!/bin/bash
# Killer Toolkit - Chinese (Simplified) Translations (locales/zh_CN.sh)

# General
STR_ERROR_PREFIX="错误:"
STR_WARNING_PREFIX="警告:"
STR_INFO_PREFIX="信息:"
STR_PRESS_ENTER_TO_CONTINUE="按回车键继续..."
STR_PRESS_ENTER_TO_RETURN="按回车键返回..."

# function.sh
STR_WELCOME_MESSAGE="🧠 欢迎使用 Killer Tools"
STR_MAIN_MENU_SEPARATOR="--------------------------"
STR_SYSINFO_MODULE="系统信息模块"
STR_INSTALLER_MODULE="软件安装模块"
STR_NETWORK_MODULE="网络工具模块"
STR_OPTIMIZE_MODULE="优化与清理模块"
STR_SECURITY_MODULE="安全模块"
STR_SERVICES_MODULE="服务管理模块"
STR_CUSTOM_MODULE="自定义脚本模块"
STR_UNKNOWN_MODULE_PREFIX="未知模块"
STR_EXIT_OPTION="0) 退出"
STR_ENTER_MODULE_PROMPT="请输入模块编号并回车: "
STR_GOODBYE="👋 再见！"
STR_INVALID_INPUT="❌ 无效输入，按回车重试..."
STR_MODULE_NO_PLUGINS_FOUND_PRE="⚠️  模块 \""
STR_MODULE_NO_PLUGINS_FOUND_POST="\" 下无可用插件，按回车返回..."
STR_CURRENT_MODULE="📁 当前模块: "
STR_UNNAMED_PLUGIN_PREFIX="未命名插件 ("
STR_UNNAMED_PLUGIN_SUFFIX=")"
STR_RETURN_TO_PREVIOUS="0) 返回上一级"
STR_ENTER_FUNCTION_PROMPT="请输入功能编号并回车: "
STR_EXECUTING_PLUGIN="🔧 即将执行插件: "
STR_CHECKING_PLUGIN_DEPENDENCIES="⚙️  正在检查并安装插件依赖..."
STR_DEPENDENCY_CHECK_COMPLETE="✅ 依赖检查完成。"
STR_REQUIREMENTS_SCRIPT_NOT_FOUND="⚠️  警告: 未找到 requirements.sh 脚本，无法检查插件依赖。"
STR_EXECUTING_PLUGIN_START="🚀 开始执行插件..."
STR_PLUGIN_EXECUTION_COMPLETE="✅ 插件执行完毕，按回车返回模块菜单..."

# start.sh
STR_DETECTING_NETWORK="🌐 正在检测网络环境..."
STR_DETECTED_MAINLAND_CHINA="🌏 检测到中国大陆网络，使用加速源..."
STR_DETECTED_NON_MAINLAND_CHINA="🌍 检测到非中国大陆网络，使用 GitHub 官方源..."
STR_DOWNLOADING_INIT_SCRIPTS="📥 下载初始化脚本..."
STR_CHANGING_SOFTWARE_SOURCES="🔧 正在更换软件源..."
STR_INSTALLING_BASE_DEPENDENCIES="📦 安装基础依赖..."
STR_DOWNLOADING_PROJECT_FROM="📦 正在从: "
STR_DOWNLOADING_PROJECT_SUFFIX=" 下载项目..."
STR_EXTRACTING_ARCHIVE="🧩 正在解压..."
STR_EXTRACT_FAILED_NO_MAIN_DIR="❌ 解压后未找到主目录！"
STR_SETTING_PERMISSIONS="🔑 正在设置脚本执行权限..."
STR_STARTING_KILLER="🚀 启动 Killer..."

# essential.sh
STR_CHECKING_ESSENTIAL_DEPENDENCIES="🔍 正在检查并安装基础依赖..."
STR_INSTALLING_PKG="📦 安装中: "
STR_PKG_ALREADY_EXISTS="✅ 已存在: "
STR_ESSENTIAL_DEPENDENCIES_INSTALLED="✅ 基础依赖安装完成。"

# requirements.sh
STR_PLUGIN_FILE_NOT_FOUND_PRE="❌ 未找到插件文件: "
STR_CHECKING_DEPENDENCIES_FOR_PLUGIN="🔍 正在检查依赖: "
STR_MISSING_DEPENDENCY_INSTALLING_PRE="📦 缺失依赖: "
STR_MISSING_DEPENDENCY_INSTALLING_POST="，正在安装..."
STR_DEPENDENCY_ALREADY_INSTALLED_POST=" 已安装"

# sources.sh
STR_AREA_NOT_DEFINED="❌ AREA 未定义，请先执行 area.sh"
STR_CONFIGURING_APT_SOURCES="🔧 正在根据系统版本和区域配置 APT 源..."
STR_USING_TSINGHUA_DEBIAN_11="使用清华源（Debian 11）"
STR_USING_OFFICIAL_DEBIAN_11="使用官方源（Debian 11）"
STR_USING_TSINGHUA_DEBIAN_12="使用清华源（Debian 12）"
STR_USING_OFFICIAL_DEBIAN_12="使用官方源（Debian 12）"
STR_UNSUPPORTED_DEBIAN_VERSION_PRE="❌ 不支持的 Debian 版本："
STR_EXECUTING_APT_UPDATE="📦 正在执行 apt update..."
STR_APT_SOURCES_CONFIG_DONE="✅ 软件源配置完成。"

# installer/01_configure_sources.sh
STR_INSTALLER_CONFIGURE_SOURCES_TITLE=">>> 智能配置 Debian 软件源 <<<"
STR_INSTALLER_DETECTING_SYSTEM_GEO="正在检测系统版本与地理位置..."
STR_INSTALLER_DEBIAN11_CN_MSG="🎯 检测到 Debian 11 + 中国大陆 IP，使用清华镜像源"
STR_INSTALLER_DEBIAN11_OTHER_MSG="🌐 Debian 11 + 非中国 IP，使用官方源"
STR_INSTALLER_DEBIAN12_CN_MSG="🎯 检测到 Debian 12 + 中国大陆 IP，使用清华镜像源"
STR_INSTALLER_DEBIAN12_OTHER_MSG="🌐 Debian 12 + 非中国 IP，使用官方源"
STR_INSTALLER_CANNOT_IDENTIFY_SYSTEM="❌ 无法识别系统版本或 IP 来源，终止操作。"

# network/01_speedtest.sh
STR_NETWORK_SPEEDTEST_START="开始测速..."

# security/01_cloudflare_ufw.sh
STR_SECURITY_CF_SYNC_UFW_TITLE="🌐 正在同步 Cloudflare IP..."
STR_SECURITY_UFW_NOT_DETECTED_INSTALLING="📦 未检测到 ufw，正在安装..."
STR_SECURITY_ALLOW_SSH_PORT_PRE="允许 SSH 端口 "
STR_SECURITY_ALLOW_SSH_PORT_POST="/tcp 登录"
STR_SECURITY_CF_RULES_SYNCED_UFW_ENABLED="✅ Cloudflare 限制规则已同步并启用 UFW"

# sysinfo/01_basic.sh
STR_SYSINFO_BASIC_TITLE="🖥️  系统基础信息"
STR_SYSINFO_SEPARATOR="-----------------------------"
STR_SYSINFO_DISTRO_VERSION="📦  发行版本 : "
STR_SYSINFO_KERNEL_VERSION="🧬  内核版本 : "
STR_SYSINFO_ARCHITECTURE="🏗️  架构类型 : "
STR_SYSINFO_HOSTNAME="💻  主机名称 : "
STR_SYSINFO_LOCAL_IP="🌐  本地 IP  : "
STR_SYSINFO_UPTIME="⏱️  运行时间 : "
STR_SYSINFO_CURRENT_USER="👥  当前用户 : "
STR_SYSINFO_MEMORY_USAGE="🧠  内存占用 :"
STR_SYSINFO_DISK_USAGE="💽  磁盘占用 :"
STR_SYSINFO_DISPLAY_COMPLETE="✅ 系统信息展示完毕。"
