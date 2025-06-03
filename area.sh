#!/bin/bash
# Name: 网络区域判断
# Output: 环境变量 AREA=CN 或 AREA=Other

# 默认先设置为 Other
AREA="Other"

# 调用 ipinfo 获取国家代码
COUNTRY=$(curl -s https://ipinfo.io/country || echo "ERR")

if [[ "$COUNTRY" == "CN" ]]; then
    AREA="CN"
fi

export AREA
