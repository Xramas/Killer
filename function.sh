#!/bin/bash
# Name: Killer 主菜单调度程序（两级结构）

# 中文模块名映射（可根据需要扩展）
declare -A module_names=(
    [sysinfo]="系统信息模块"
    [installer]="软件安装模块"
    [network]="网络工具模块"
    [optimize]="优化与清理模块"
    [security]="安全模块"
    [services]="服务管理模块"
    [custom]="自定义脚本模块"
)

# 读取所有一级模块目录
readarray -t modules < <(find . -maxdepth 1 -type d | grep -vE '^\.$' | sort)

while true; do
    clear
    echo "🧠 欢迎使用 Killer Tools"
    echo "--------------------------"

    # 一级菜单展示模块名
    index=1
    declare -A module_map
    for dir in "${modules[@]}"; do
        name=${dir#./}
        chname="${module_names[$name]:-未知模块 ($name)}"
        printf " %2d) %s\n" "$index" "$chname"
        module_map[$index]="$dir"
        ((index++))
    done

    echo " $index) 退出"
    read -p $'\n请输入模块编号并回车: ' mod_choice

    if [[ "$mod_choice" =~ ^[0-9]+$ && "$mod_choice" -ge 1 && "$mod_choice" -lt "$index" ]]; then
        selected_module="${module_map[$mod_choice]}"
        show_plugins "$selected_module"
    else
        echo "👋 再见！"
        break
    fi
done

# 二级菜单函数
function show_plugins() {
    local module_dir="$1"
    clear
    echo "🧩 模块：$module_dir"
    echo "--------------------------"

    mapfile -t plugins < <(find "$module_dir" -type f -name '[0-9][0-9]_*.sh' | sort)
    declare -A plugin_map

    local pidx=1
    for file in "${plugins[@]}"; do
        name=$(grep -E '^# Name:' "$file" | cut -d: -f2- | xargs)
        [[ -z "$name" ]] && name="未命名插件 ($file)"
        printf " %2d) %s\n" "$pidx" "$name"
        plugin_map[$pidx]="$file"
        ((pidx++))
    done

    echo " $pidx) 返回上一级"
    read -p $'\n请输入插件编号并回车: ' plugin_choice

    if [[ "$plugin_choice" =~ ^[0-9]+$ && "$plugin_choice" -ge 1 && "$plugin_choice" -lt "$pidx" ]]; then
        clear
        bash "${plugin_map[$plugin_choice]}"
        read -p $'\n按回车键返回模块菜单...' _
        show_plugins "$module_dir"
    fi
}
