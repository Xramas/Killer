#!/bin/bash
# Name: Killer 插件骨架生成器

MODULES=("sysinfo" "installer" "network" "optimize" "security" "services" "custom")

echo "📁 可用模块："
for i in "${!MODULES[@]}"; do
    printf " %2d) %s\n" $((i+1)) "${MODULES[$i]}"
done

read -p $'\n请输入模块编号: ' mod_idx
((mod_idx--))

if [[ "$mod_idx" -lt 0 || "$mod_idx" -ge "${#MODULES[@]}" ]]; then
    echo "❌ 模块编号无效"
    exit 1
fi

TARGET_DIR="./${MODULES[$mod_idx]}"
[[ ! -d "$TARGET_DIR" ]] && mkdir -p "$TARGET_DIR"

read -p "请输入插件名称（中文描述）： " plugin_name

# 自动编号
last=$(find "$TARGET_DIR" -maxdepth 1 -type f -name '[0-9][0-9]_*.sh' | wc -l)
id=$(printf "%02d" $((last + 1)))

filename="${TARGET_DIR}/${id}_$(echo "$plugin_name" | tr ' ' '_' | tr -cd '[:alnum:]_').sh"

# 写入骨架
cat > "$filename" <<EOF
#!/bin/bash
# Name: $plugin_name

echo "🔧 插件：$plugin_name 正在执行..."
# TODO: 在此添加你的脚本逻辑
EOF

chmod +x "$filename"
echo "✅ 插件已创建: $filename"
