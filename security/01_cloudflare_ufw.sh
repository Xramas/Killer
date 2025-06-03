#!/bin/bash
# Name: 同步 Cloudflare IP 到 UFW 并限制非CDN访问

echo "🌐 正在同步 Cloudflare IP..."

# 依赖检测
if ! command -v ufw &>/dev/null; then
    echo "📦 未检测到 ufw，正在安装..."
    apt update -y && apt install -y ufw
fi

# 检测 SSH 端口（避免被锁）
SSH_PORT=$(ss -tnlp | grep sshd | awk '{print $4}' | awk -F: '{print $NF}' | sort -u | head -n1)
if [[ -z "$SSH_PORT" ]]; then
    SSH_PORT=22
fi
ufw allow $SSH_PORT/tcp comment "允许 SSH 端口登录"

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

echo "✅ Cloudflare 限制规则已同步并启用 UFW"
