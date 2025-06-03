#!/bin/bash
# Name: 汇总并安装所有插件声明的依赖

echo "🔍 正在扫描插件所需依赖..."

# 遍历所有插件文件，抽取 Requires 字段
mapfile -t requires < <(grep -h '^# Requires:' ./*/*.sh | cut -d: -f2- | xargs | tr ' ' '\n' | sort -u)

if [ ${#requires[@]} -eq 0 ]; then
    echo "✅ 未声明任何依赖，跳过安装"
    exit 0
fi

echo "📦 需要安装以下依赖项:"
printf " - %s\n" "${requires[@]}"

# 更新 apt 索引一次
apt update -y

# 遍历安装
for pkg in "${requires[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "📥 安装中: $pkg"
        apt install -y "$pkg"
    else
        echo "✅ 已存在: $pkg"
    fi
done

echo "🎉 所有依赖处理完成。"
