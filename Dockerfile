FROM ubuntu:latest

# 避免交互式前端
ENV DEBIAN_FRONTEND=noninteractive

# 设置隧道令牌环境变量（默认为空，在运行时提供）
ENV TUNNEL_TOKEN=""

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y \
    curl \
    sudo \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 添加Cloudflare GPG密钥
RUN mkdir -p --mode=0755 /usr/share/keyrings && \
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# 添加Cloudflare仓库
RUN echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | tee /etc/apt/sources.list.d/cloudflared.list

# 安装cloudflared
RUN apt-get update && apt-get install -y cloudflared

# 配置Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html

# 创建启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 暴露80端口
EXPOSE 80

# 设置容器启动命令
CMD ["/start.sh"]