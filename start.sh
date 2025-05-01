#!/bin/bash
set -e

# 检查是否提供了隧道令牌
if [ -z "$TUNNEL_TOKEN" ]; then
  echo "错误: 未提供TUNNEL_TOKEN环境变量"
  echo "请使用 -e TUNNEL_TOKEN=你的令牌 运行容器"
  exit 1
fi

echo "启动Nginx服务..."
nginx -g "daemon off;" &
NGINX_PID=$!

echo "正在安装Cloudflare隧道服务..."
cloudflared service install $TUNNEL_TOKEN

echo "启动Cloudflare隧道..."
cloudflared tunnel run &
CLOUDFLARED_PID=$!

# 等待任意进程结束
wait -n

# 如果有一个进程结束，则终止另一个进程
if kill -0 $NGINX_PID 2>/dev/null; then
  echo "Cloudflare隧道已停止，正在停止Nginx..."
  kill $NGINX_PID
else
  echo "Nginx已停止，正在停止Cloudflare隧道..."
  kill $CLOUDFLARED_PID 2>/dev/null || true
fi

echo "容器已停止"
exit 1