# OpenConnect SOCKS5

这个镜像连接 OpenConnect VPN，并通过 gost 提供 SOCKS5 代理。默认代理端口为 `53200`。

## 配置

编辑 `openconnect/.env`：

```dotenv
LDAP_USER=your_username
LDAP_PASSWD=your_password
VPN_SERVER=your_vpn_server
GOST_PORT=53200
```

不要把真实凭据提交到仓库。`docker-compose.yaml` 通过 `env_file` 加载这些变量。

## 使用

容器需要访问 TUN 设备和网络管理权限：

```bash
cd openconnect
docker compose up -d
```

SOCKS5 代理地址为 `127.0.0.1:53200`。停止服务：

```bash
docker compose down
```

使用前请根据实际服务修改 `docker-compose.yaml` 中的 healthcheck；当前示例检查地址 `http://xxx` 是占位值。

## 构建

该镜像当前只构建 `linux/amd64`：

```bash
./openconnect/build.sh
```

镜像包含 OpenConnect、gost 和仓库中的 `openconnect.conf`、`start.sh`。
