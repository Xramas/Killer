#!/bin/bash
# Name: 清理 Killer 临时文件

# 用法：bash cleanup.sh [init|zip|all]
MODE=${1:-all}

if [[ $MODE == "init" || $MODE == "all" ]]; then
    rm -f /tmp/area.sh /tmp/sources.sh /tmp/essential.sh /tmp/function.sh
fi

if [[ $MODE == "zip" || $MODE == "all" ]]; then
    rm -f /tmp/killer.zip
    rm -rf /tmp/killer-tools
fi
