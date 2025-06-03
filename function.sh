#!/bin/bash
# Name: Killer 主程序菜单（自动模块 + 依赖检查）

set -e

KILLER_ROOT=$(pwd)

# 自动加载所有模块目录（一级菜单）
MODULE_DIRS=$(find . -maxdepth 1 -type d ! -name '.' | sort)

declare -A module_map

show_main_menu() {
  clear
  echo "🧠 欢迎使用 Killer Tools"
  echo "--------------------------"

  index=1
  for dir in $MODULE_DIRS; do
    name=$(basename "$dir")
    case "$name" in
      sysinfo) title="系统信息模块" ;;
      installer) title="软件安装模块" ;;
      network) title="网络工具模块" ;;
      optimize) title="优化与清理模块" ;;
      security) title="安全模块" ;;
      services) title="服务管理模块" ;;
      custom) title="自定义脚本模块" ;;
      *) title="未知模块 ($name)" ;;
    esac
    echo "  $index) $title"
    module_map[$index]="$dir"
    ((index++))
  done

  echo "  0) 退出"
  read -rp $'\n请输入模块编号并回车: ' mod_choice

  if [[ "$mod_choice" == "0" ]]; then
    echo "👋 再见！"
    exit 0
  elif [[ "${module_map[$mod_choice]}" != "" ]]; then
    show_plugins "${module_map[$mod_choice]}"
  else
    echo "❌ 无效输入，按回车重试..."
    read
  fi
}

show_plugins() {
  local module="$1"
  local files=("$module"/*.sh)

  if [[ ! -e "${files[0]}" ]]; then
    echo "⚠️ 模块 \"$module\" 下无可用插件，按回车返回..."
    read
    return
  fi

  while true; do
    clear
    echo "📁 当前模块: $module"
    echo "--------------------------"
    local idx=1
    declare -A plugin_map=()

    for f in "${files[@]}"; do
      name=$(grep -m1 "^# Name:" "$f" | cut -d':' -f2- | xargs)
      [[ -z "$name" ]] && name="未命名插件 ($f)"
      echo "  $idx) $name"
      plugin_map[$idx]="$f"
      ((idx++))
    done

    echo "  0) 返回上一级"
    read -rp $'\n请输入功能编号并回车: ' plugin_choice

    if [[ "$plugin_choice" == "0" ]]; then
      break
    elif [[ "${plugin_map[$plugin_choice]}" != "" ]]; then
      plugin_path="${plugin_map[$plugin_choice]}"
      echo "🔧 执行插件: $plugin_path"

      # 插件依赖检查
      if [[ -f "$KILLER_ROOT/requirements.sh" ]]; then
        bash "$KILLER_ROOT/requirements.sh" "$plugin_path"
      fi

      bash "$plugin_path"

      echo -e "\n✅ 执行完毕，按回车返回模块菜单..."
      read
    else
      echo "❌ 无效输入，按回车重试..."
      read
    fi
  done
}

# 主循环
while true; do
  show_main_menu
done
