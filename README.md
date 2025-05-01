# Cloudflare 隧道 Docker 镜像

这个 Docker 镜像用于运行 Cloudflare 隧道服务，同时包含一个Nginx服务器来托管静态网页，可以安全地将您的服务暴露到互联网上。

## 功能

- Cloudflare 隧道服务
- Nginx 网页服务器（监听80端口）
- 默认展示的静态页面

## 安全提示

⚠️ **重要**: 隧道令牌包含敏感信息，不应该硬编码到 Dockerfile 中或提交到代码仓库中。

## 使用方法

### 构建镜像

```bash
docker build -t cloudflare-tunnel .
```

### 运行容器

使用您的隧道令牌运行容器:

```bash
docker run -d --name cf-tunnel -p 80:80 -e TUNNEL_TOKEN="您的隧道令牌" cloudflare-tunnel
```

您的隧道令牌可以从 Cloudflare Zero Trust 仪表板获取。

### 使用 Docker Compose

也可以使用 Docker Compose 运行:

```yaml
version: '3'
services:
  cloudflare-tunnel:
    build: .
    ports:
      - "80:80"
    environment:
      - TUNNEL_TOKEN=您的隧道令牌
    restart: unless-stopped
```

## 环境变量

- `TUNNEL_TOKEN` (必需): 您的 Cloudflare 隧道令牌

## 查看日志

```bash
docker logs cf-tunnel
```

## 查看隧道状态

```bash
docker exec cf-tunnel cloudflared tunnel info
```

## 在 Render 上部署

1. 在 Render 上创建一个 Web Service
2. 连接您的 GitHub 仓库
3. 设置以下配置:
   - 构建命令: 留空
   - 启动命令: `bash start.sh`
   - 环境变量: 添加 `TUNNEL_TOKEN` 环境变量并设置为您的隧道令牌
   - 计划: 选择合适的计划

Render 将自动使用您的 Dockerfile 构建镜像并运行容器。访问分配的 Render URL 即可看到您的页面。

## 自定义网页内容

如需更改网页内容，请修改 `index.html` 文件，然后重新构建镜像。

## 许可证

MIT