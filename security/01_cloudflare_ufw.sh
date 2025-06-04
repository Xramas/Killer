#!/bin/bash
# Name: 同步 Cloudflare IP 到 UFW 并限制非CDN访问

# Source i18n so the script can run standalone or via function.sh
if [[ -n "$STR_SECURITY_CF_SYNC_UFW_TITLE" ]]; then
    :
elif [[ -f "./i18n.sh" ]]; then
    source "./i18n.sh"
elif [[ -f "../i18n.sh" ]]; then
    source "../i18n.sh"
else
    echo "Warning: i18n.sh not found in 01_cloudflare_ufw.sh. Using fallback messages."
    STR_SECURITY_CF_SYNC_UFW_TITLE="🌐 Syncing Cloudflare IPs to UFW..."
    STR_SECURITY_UFW_NOT_DETECTED_INSTALLING="📦 ufw not detected, installing..."
    STR_SECURITY_ALLOW_SSH_PORT_PRE="Allowing SSH port "
    STR_SECURITY_ALLOW_SSH_PORT_POST="/tcp for login"
    STR_SECURITY_CF_RULES_SYNCED_UFW_ENABLED="✅ Cloudflare restriction rules synced and UFW enabled."
fi

echo "$STR_SECURITY_CF_SYNC_UFW_TITLE"

# 依赖检测
if ! command -v ufw &>/dev/null; then
    echo "$STR_SECURITY_UFW_NOT_DETECTED_INSTALLING"
    apt update -y && apt install -y ufw
fi

# 检测 SSH 端口（避免被锁）
SSH_PORT=$(ss -tnlp | grep sshd | awk '{print $4}' | awk -F: '{print $NF}' | sort -u | head -n1)
if [[ -z "$SSH_PORT" ]]; then
    SSH_PORT=22
fi
ufw allow $SSH_PORT/tcp comment "${STR_SECURITY_ALLOW_SSH_PORT_PRE}${SSH_PORT}${STR_SECURITY_ALLOW_SSH_PORT_POST}"

# 下载 Cloudflare IP 列表
CF_IPV4_URL="https://www.cloudflare.com/ips-v4"
CF_IPV6_URL="https://www.cloudflare.com/ips-v6"
TMP_IPV4="/tmp/cf-ips-v4.txt"
TMP_IPV6="/tmp/cf-ips-v6.txt"

curl -s "$CF_IPV4_URL" -o "$TMP_IPV4"
curl -s "$CF_IPV6_URL" -o "$TMP_IPV6"

# 删除旧规则（Cloudflare）
ufw status numbered | grep 'Cloudflare' | awk -F'[][]' '{print $2}' | tac | while read num; do
    ufw --force delete "$num"
done

# 添加 IPv4 白名单
while read ip; do
    ufw allow from "$ip" to any port 80 proto tcp comment 'Cloudflare'
    ufw allow from "$ip" to any port 443 proto tcp comment 'Cloudflare'
done < "$TMP_IPV4"

# 添加 IPv6 白名单
while read ip; do
    ufw allow from "$ip" to any port 80 proto tcp comment 'Cloudflare'
    ufw allow from "$ip" to any port 443 proto tcp comment 'Cloudflare'
done < "$TMP_IPV6"

# 拒绝非 Cloudflare 的 HTTP/HTTPS 请求
ufw deny in proto tcp to any port 80 comment 'Deny non-Cloudflare HTTP'
ufw deny in proto tcp to any port 443 comment 'Deny non-Cloudflare HTTPS'

# 启用防火墙
ufw --force enable

echo "$STR_SECURITY_CF_RULES_SYNCED_UFW_ENABLED"
