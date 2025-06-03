#!/bin/bash
# Killer Tools 主程序
# 自动遍历插件目录，读取 Name 标签生成菜单

clear
echo "欢迎使用 Killer Tools"
echo "----------------------------"

# 获取插件列表（支持二级目录 + 排序）
mapfile -t plugin_files < <(find . -type f -path "./*/[0-9][0-9]_*.sh" | sort)

# 插件名与路径索引
declare -A plugin_map

# 构建菜单
index=1
for file in "${plugin_files[@]}"; do
    name=$(grep -E '^# Name:' "$file" | head -n1 | cut -d: -f2- | xargs)
    [[ -z "$name" ]] && name="未命名插件 ($file)"
    printf "%2d) %s\n" "$index" "$name"
    plugin_map["$index"]="$file"
    ((index++))
done

# 添加退出选项
printf "%2d) 退出工具箱\n" "$index"

# 等待用户输入
echo
read -p "请输入编号以执行对应功能: " choice
echo

# 执行插件或退出
if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 1 && "$choice" -lt "$index" ]]; then
    bash "${plugin_map[$choice]}"
else
    echo "感谢使用 Killer Tools！"
    exit 0
fi
