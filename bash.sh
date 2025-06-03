#!/bin/bash

clear
echo "欢迎使用 Killer Tools！"
echo "----------------------------"

# 查找所有插件（顺序执行：子目录下的 *.sh）
mapfile -t plugin_files < <(find . -type f -path './*/[0-9][0-9]_*.sh' | sort)

declare -A plugin_names

# 读取每个插件的 Name 并编号菜单
index=1
for file in "${plugin_files[@]}"; do
    name=$(grep -E '^# Name:' "$file" | head -n1 | cut -d: -f2- | xargs)
    if [[ -z "$name" ]]; then
        name="(未命名插件) $file"
    fi
    plugin_names[$index]="$file"
    echo "$index) $name"
    ((index++))
done

echo "$index) 退出"

# 选择执行
read -p "请输入选项编号: " choice
if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 1 && "$choice" -lt "$index" ]]; then
    bash "${plugin_names[$choice]}"
else
    echo "已退出。"
fi
