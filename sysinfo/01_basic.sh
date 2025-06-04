#!/bin/bash
# Name: 显示基础系统信息

echo "🖥️  系统基础信息"
echo "-----------------------------"

# 系统名称和版本
if command -v lsb_release &>/dev/null; then
    echo "📦  发行版本 : $(lsb_release -ds)"
else
    echo "📦  发行版本 : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
fi

# 内核版本
echo "🧬  内核版本 : $(uname -r)"

# 架构信息
echo "🏗️  架构类型 : $(uname -m)"

# 主机名和 IP
echo "💻  主机名称 : $(hostname)"
echo "🌐  本地 IP  : $(hostname -I | awk '{print $1}')"

# Uptime
echo "⏱️  运行时间 : $(uptime -p)"

# 登录用户
echo "👥  当前用户 : $(whoami)"

# 内存使用
echo "🧠  内存占用 :"
free -h

# 磁盘使用情况
echo "💽  磁盘占用 :"
df -hT --total | grep -E '^Filesystem|^total'

echo "✅ 系统信息展示完毕。"
