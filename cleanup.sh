#!/bin/bash
# Name: Killer 临时目录自动清理器

# 默认临时工作目录
WORKDIR="/tmp/killer-tools"

cleanup() {
    if [[ -d "$WORKDIR" ]]; then
        echo -e "\n🧹 正在清理临时文件夹: $WORKDIR"
        rm -rf "$WORKDIR"
    fi
}

# 注册退出、错误、中断时清理
trap cleanup EXIT INT ERR
