#!/bin/bash
set -e

# 检查是否提供了隧道令牌
if [ -z "$TUNNEL_TOKEN" ]; then
  echo "错误: 未提供TUNNEL_TOKEN环境变量"
  echo "请使用 -e TUNNEL_TOKEN=你的令牌 运行容器"
  exit 1
fi

echo "正在安装Cloudflare隧道服务..."
cloudflared service install $TUNNEL_TOKEN

echo "启动Cloudflare隧道..."
cloudflared tunnel run

# 容器会在隧道关闭时退出