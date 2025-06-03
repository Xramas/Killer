#!/bin/bash
# 用法: bash requirements.sh /path/to/plugin.sh

PLUGIN_FILE="$1"

if [[ ! -f "$PLUGIN_FILE" ]]; then
    echo "❌ 未找到插件文件: $PLUGIN_FILE"
    exit 1
fi

# 提取依赖声明行
REQUIRE_LINE=$(grep -E '^# ?Require:' "$PLUGIN_FILE")
if [[ -z "$REQUIRE_LINE" ]]; then
    exit 0  # 无依赖，跳过
fi

# 解析依赖名
REQUIRES=$(echo "$REQUIRE_LINE" | cut -d':' -f2 | tr -s ' ')

echo "🔍 正在检查依赖: $REQUIRES"

for pkg in $REQUIRES; do
    if ! command -v "$pkg" &>/dev/null; then
        echo "📦 缺失依赖: $pkg，正在安装..."
        apt install -y "$pkg"
    else
        echo "✅ $pkg 已安装"
    fi
done
