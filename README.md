# Containers

这个仓库包含了各种 Docker 容器的配置和使用说明。

## 目录

- [Containers](#containers)
  - [目录](#目录)
  - [noVNC](#novnc)
    - [使用方法](#使用方法)
    - [参数说明](#参数说明)
  - [OpenConnect-socks5](#openconnect-socks5)
    - [前置条件](#前置条件)
    - [使用方法](#使用方法-1)
    - [配置说明](#配置说明)
    - [注意事项](#注意事项)

## noVNC

noVNC 是一个基于 HTML5 的 VNC 客户端，可以通过浏览器访问 VNC 服务器。

### 使用方法

运行容器：

```bash
docker run --rm --name novnc \
    -p 6080:6080 \
    -e VNC_SERVER=192.168.2.100:5900 \
    ghcr.io/jimyag/novnc:latest
```

在浏览器中访问：

- 打开 `http://localhost:6080`

### 参数说明

- `-p 6080:6080`: 映射容器的 6080 端口到主机的 6080 端口
- `-e VNC_SERVER`: 设置 VNC 服务器地址和端口

## OpenConnect-socks5

这是一个基于 OpenConnect VPN 的 socks5 代理服务。它通过 OpenConnect 连接到 VPN 服务器，并将连接转换为 socks5 代理服务，方便其他应用程序使用。

### 前置条件

创建 `.env` 文件并配置以下环境变量：

```bash
LDAP_USER=admin
LDAP_PASSWD=123456
VPN_SERVER=test.abc.com
GOST_PORT=53200
```

### 使用方法

使用 Docker Compose 启动服务：

```bash
docker compose up -d
```

配置应用程序使用 socks5 代理：

- 代理地址：`127.0.0.1:53200`
- 代理类型：socks5

### 配置说明

- `cap_add`: 添加必要的容器权限
  - `NET_ADMIN`: 网络管理权限
  - `MKNOD`: 创建设备节点权限
- `devices`: 挂载 TUN 设备
- `ports`: 映射 socks5 代理端口
- `healthcheck`: 容器健康检查配置

### 注意事项

- 确保主机系统支持 TUN 设备
- 需要正确配置 VPN 服务器地址和认证信息
- 建议在生产环境中使用更安全的密码
- socks5 代理服务默认监听在 53200 端口

```bash
docker compose up -d
```
