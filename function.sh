#!/bin/bash
# Name: Killer 主程序菜单 (Killer Main Program Menu)

# Source i18n helper. Assumes i18n.sh is in the same directory.
BASE_DIR_FUNC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [[ -f "$BASE_DIR_FUNC/i18n.sh" ]]; then
    source "$BASE_DIR_FUNC/i18n.sh"
else
    echo "FATAL: i18n.sh not found in $BASE_DIR_FUNC. Cannot proceed."
    echo "Make sure Killer is installed correctly with all its components."
    exit 1
fi

set -e

# Auto-load all module directories (first-level menu)
MODULE_DIRS=$(find . -maxdepth 1 -type d ! -name '.' ! -name 'locales' | sort) # Exclude locales dir

declare -A module_map

show_main_menu() {
  clear
  echo "$STR_WELCOME_MESSAGE"
  echo "$STR_MAIN_MENU_SEPARATOR"

  index=1
  for dir in $MODULE_DIRS; do
    name=$(basename "$dir")
    local title_var_name="STR_$(echo "$name" | tr '[:lower:]' '[:upper:]')_MODULE"
    title="${!title_var_name}" # Get title from variable, e.g. STR_SYSINFO_MODULE

    if [[ -z "$title" ]]; then # Fallback if specific module title not defined
        title="$STR_UNKNOWN_MODULE_PREFIX ($name)"
    fi
    echo "  $index) $title"
    module_map[$index]="$dir"
    ((index++))
  done

  echo "  $STR_EXIT_OPTION"
  read -p $'\n'"$STR_ENTER_MODULE_PROMPT" mod_choice

  if [[ "$mod_choice" == "0" ]]; then
    echo "$STR_GOODBYE"
    # Cleanup is handled by trap in start.sh, but if function.sh can be run directly:
    # if [[ -f "./cleanup.sh" ]]; then ./cleanup.sh all; fi
    exit 0
  elif [[ "${module_map[$mod_choice]}" != "" ]]; then
    show_plugins "${module_map[$mod_choice]}"
  else
    echo "$STR_INVALID_INPUT"
    read
  fi
}

show_plugins() {
  local module="$1"
  local files=("$module"/*.sh)

  if [[ ! -e "${files[0]}" ]]; then
    echo "${STR_MODULE_NO_PLUGINS_FOUND_PRE}$module${STR_MODULE_NO_PLUGINS_FOUND_POST}"
    read
    return
  fi

  while true; do
    clear
    local module_basename=$(basename "$module")
    local current_module_title_var="STR_$(echo "$module_basename" | tr '[:lower:]' '[:upper:]')_MODULE"
    local current_module_title="${!current_module_title_var}"
    if [[ -z "$current_module_title" ]]; then
        current_module_title="$module_basename" # Fallback to directory name
    fi
    echo "$STR_CURRENT_MODULE $current_module_title" # Using translated module title
    echo "$STR_MAIN_MENU_SEPARATOR"
    local idx=1
    declare -A plugin_map=()

    for f in "${files[@]}"; do
      # Plugin names are extracted from # Name: comment.
      # These comments themselves are not easily translated without changing the plugin file format.
      # So, plugin names will appear as they are in the # Name: comment.
      name=$(grep -m1 "^# Name:" "$f" | cut -d':' -f2- | xargs)
      [[ -z "$name" ]] && name="${STR_UNNAMED_PLUGIN_PREFIX}$f${STR_UNNAMED_PLUGIN_SUFFIX}"
      echo "  $idx) $name"
      plugin_map[$idx]="$f"
      ((idx++))
    done

    echo "  $STR_RETURN_TO_PREVIOUS"
    read -p $'\n'"$STR_ENTER_FUNCTION_PROMPT" plugin_choice

    if [[ "$plugin_choice" == "0" ]]; then
      break
    elif [[ "${plugin_map[$plugin_choice]}" != "" ]]; then
      echo "$STR_EXECUTING_PLUGIN ${plugin_map[$plugin_choice]}"
      
      if [[ -f "./requirements.sh" ]]; then
        echo "$STR_CHECKING_PLUGIN_DEPENDENCIES"
        # requirements.sh should also be modified to use i18n for its output
        bash ./requirements.sh "${plugin_map[$plugin_choice]}"
        echo "$STR_DEPENDENCY_CHECK_COMPLETE"
      else
        echo "$STR_REQUIREMENTS_SCRIPT_NOT_FOUND"
      fi
      
      echo "$STR_EXECUTING_PLUGIN_START"
      bash "${plugin_map[$plugin_choice]}" # The plugin itself should handle its own i18n if it has output
      echo -e "\n$STR_PLUGIN_EXECUTION_COMPLETE"
      read
    else
      echo "$STR_INVALID_INPUT"
      read
    fi
  done
}

# Main loop
while true; do
  show_main_menu
done
