# OpenVPN + GOST

Debian 13.7 上运行 OpenVPN 2.7.8 和 GOST 3.3.0，代理入口同时支持 HTTP 和 SOCKS5。
镜像为 `ghcr.io/jimyag/openvpn-gost:2.7.8-gost3.3.0`，另发布 `latest`。
当前提供 linux/amd64。基础镜像锁定 digest，两个上游发布包校验 SHA-256。

## 运行

将 IPv4 tun 客户端配置放在 `config/client.ovpn`，用户名和密码分别写入
`config/auth.txt` 的两行，并设置权限为 0600。容器只读挂载此目录，
命令行认证路径会覆盖 profile 中的旧路径。其他证书文件也需置于此目录，
在 profile 中使用 `/config/` 下的绝对路径。

在 `.env` 中设置：

```dotenv
DNS_IP=192.168.2.10
RETURN_ROUTES=192.168.2.0/24
HEALTHCHECK_URL=https://your-internal-service.example
```

`RETURN_ROUTES` 使用空格分隔，包含代理客户端及 DNS 所在网段，
确保全隧道连接后的回复仍能通过原网关返回。DNS_IP 必须是 IPv4 地址。
profile 支持 TCP 或 UDP，需建立到 `tun0` 的 IPv4 全隧道路由。

```bash
docker compose up -d --wait
docker compose ps
curl --proxy socks5h://127.0.0.1:53200 https://your-internal-service.example
```

仅授予 NET_ADMIN 和 TUN 设备。防火墙只允许 VPN 隧道、VPN 服务端控制流量、
指定 DNS 和代理连接的回复；IPv6 出站阻断。VPN 断线时普通网络不能承接代理出站。

健康检查每 30 秒确认公共 IPv4 路由经过 tun0，并通过本地 SOCKS5 请求配置的
HTTPS 地址，连续三次失败标记 unhealthy。HTTP 2xx/3xx 为成功，4xx/5xx 为失败。
OpenVPN 或 GOST 进程退出会结束容器，Compose 的 unless-stopped 策略负责重启；
仅健康状态变为 unhealthy 不会自动触发 Docker 重启。

## 构建与发布

在仓库根目录构建：

```bash
docker buildx build --platform linux/amd64 --load \
  -t ghcr.io/jimyag/openvpn-gost:2.7.8-gost3.3.0 openvpn-gost
```

`openvpn-gost/build.sh` 构建并推送固定版本和 latest 标签，沿用仓库的 tag 发布工作流。
升级时同步修改 Dockerfile 中的版本和校验值、build.sh 和示例镜像标签。
