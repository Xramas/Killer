#!/bin/bash
# Name: Killer 主程序菜单

set -e

KILLER_ROOT=$(pwd)

# 菜单模块列表（显示顺序）
MODULES=(
    "custom::自定义脚本模块"
    "installer::软件安装模块"
    "network::网络工具模块"
    "optimize::优化与清理模块"
    "security::安全模块"
    "services::服务管理模块"
    "sysinfo::系统信息模块"
)

while true; do
    echo -e "\n🧠 欢迎使用 Killer Tools"
    echo "--------------------------"
    for i in "${!MODULES[@]}"; do
        IFS="::" read -r dir label <<< "${MODULES[$i]}"
        printf " %2d) %s\n" $((i + 1)) "$label"
    done
    echo "  0) 退出"
    echo ""

    read -rp "请输入模块编号并回车: " choice
    if [[ "$choice" == "0" ]]; then
        echo "👋 再见！"
        exit 0
    elif [[ "$choice" =~ ^[1-9][0-9]*$ && "$choice" -le ${#MODULES[@]} ]]; then
        IFS="::" read -r MODULE_KEY _ <<< "${MODULES[$((choice - 1))]}"
        MODULE_PATH="$KILLER_ROOT/$MODULE_KEY"

        if [[ ! -d "$MODULE_PATH" ]]; then
            echo "❌ 模块目录不存在: $MODULE_PATH"
            continue
        fi

        echo -e "\n📂 进入模块: $MODULE_KEY"
        echo "--------------------------"

        PLUGINS=($(find "$MODULE_PATH" -maxdepth 1 -type f -name "*.sh" | sort))

        if [[ "${#PLUGINS[@]}" -eq 0 ]]; then
            echo "⚠️ 该模块下暂无插件"
            continue
        fi

        while true; do
            echo ""
            for i in "${!PLUGINS[@]}"; do
                NAME_LINE=$(grep -E "^# ?Name:" "${PLUGINS[$i]}")
                NAME=$(echo "$NAME_LINE" | cut -d':' -f2 | sed 's/^ *//')
                NAME=${NAME:-未命名插件}
                printf " %2d) %s (%s)\n" $((i + 1)) "$NAME" "$(basename "${PLUGINS[$i]}")"
            done
            echo "  0) 返回主菜单"
            echo ""

            read -rp "请输入功能编号并回车: " sub_choice
            if [[ "$sub_choice" == "0" ]]; then
                break
            elif [[ "$sub_choice" =~ ^[1-9][0-9]*$ && "$sub_choice" -le ${#PLUGINS[@]} ]]; then
                PLUGIN_PATH="${PLUGINS[$((sub_choice - 1))]}"
                echo -e "\n▶️ 正在执行插件: $PLUGIN_PATH"

                bash "$KILLER_ROOT/requirements.sh" "$PLUGIN_PATH"
                bash "$PLUGIN_PATH"
            else
                echo "❌ 无效输入"
            fi
        done
    else
        echo "❌ 无效输入"
    fi
done
