# Cloudflare 隧道 Docker 镜像

这个 Docker 镜像用于运行 Cloudflare 隧道服务，可以安全地将您的本地服务暴露到互联网上。

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
docker run -d --name cf-tunnel -e TUNNEL_TOKEN="您的隧道令牌" cloudflare-tunnel
```

您的隧道令牌可以从 Cloudflare Zero Trust 仪表板获取。

### 使用 Docker Compose

也可以使用 Docker Compose 运行:

```yaml
version: '3'
services:
  cloudflare-tunnel:
    build: .
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

## 许可证

MIT