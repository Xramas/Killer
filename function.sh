#!/bin/bash
# Name: Killer 主菜单调度程序

clear
echo "🧠 欢迎使用 Killer Tools"
echo "--------------------------"

# 查找插件（目录递归）并排序
mapfile -t plugins < <(find . -type f -path "./*/[0-9][0-9]_*.sh" | sort)

declare -A plugin_map

# 构建菜单
index=1
for file in "${plugins[@]}"; do
    name=$(grep -E '^# Name:' "$file" | cut -d: -f2- | xargs)
    [[ -z "$name" ]] && name="未命名插件 ($file)"
    printf "%2d) %s\n" "$index" "$name"
    plugin_map[$index]="$file"
    ((index++))
done

# 添加退出项
echo "$index) 退出"

# 用户输入
read -p $'\n请输入功能编号并回车: ' choice
echo

if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 1 && "$choice" -lt "$index" ]]; then
    bash "${plugin_map[$choice]}"
else
    echo "👋 再见！"
fi
