#!/bin/bash
# Name: 安装基础依赖

ESSENTIALS=(curl unzip lsb-release)

echo "🔍 正在检查并安装基础依赖..."
apt update -y

for pkg in "${ESSENTIALS[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "📦 安装中: $pkg"
        apt install -y "$pkg"
    else
        echo "✅ 已存在: $pkg"
    fi
done

echo "✅ 基础依赖安装完成。"
