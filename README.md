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
  - [debug](#debug)
    - [使用方法](#使用方法-2)
    - [包含的工具](#包含的工具)
    - [权限边界](#权限边界)

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

## debug

`debug` 是一个面向 Kubernetes 临时排障的工具箱镜像。它包含网络工具，也包含进程、文件系统、存储、压缩、调试器、硬件信息、Python、SQLite 和常见数据库客户端，适合配合 Ephemeral Container 使用。

MongoDB 客户端使用官方 `mongosh`，进入调试容器后可以直接运行 `mongosh --host <host> --port <port>`。镜像按 amd64 和 arm64 架构安装固定版本的官方 MongoDB Shell 包。

### 使用方法

直接调试指定 Pod：

```bash
kubectl debug -n production pod/web-xxx \
    -it \
    --image=ghcr.io/jimyag/debug:latest \
    --target=app \
    --container=debug \
    -- bash
```

按 label 选择 Pod 后再注入：

```bash
set -eu

namespace=production
selector='app=web'

pods=$(kubectl get pods -n "$namespace" -l "$selector" \
    --field-selector=status.phase=Running \
    -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
count=$(printf '%s\n' "$pods" | awk 'NF {count++} END {print count + 0}')
if [ "$count" -ne 1 ]; then
    echo "expected exactly one Running Pod" >&2
    printf '%s\n' "$pods" | sed '/^$/d' >&2
    exit 1
fi

pod=$(printf '%s\n' "$pods" | awk 'NF {print; exit}')

kubectl debug -n "$namespace" "pod/$pod" \
    -it \
    --image=ghcr.io/jimyag/debug:latest \
    --target=app \
    --container=debug \
    -- bash
```

### 包含的工具

- 网络：`ip`、`ss`、`ping`、`arping`、`tracepath`、`traceroute`、`mtr`、`dig`、`nslookup`、`curl`、`wget`、`nc`、`socat`、`tcpdump`、`nmap`、`ethtool`、`conntrack`、`telnet`。
- 进程和系统：`ps`、`top`、`htop`、`pgrep`、`pkill`、`pstree`、`fuser`、`lsof`、`free`、`vmstat`、`iostat`、`pidstat`、`strace`、`ltrace`、`gdb`。
- 文件和文本：`find`、`fd`、`rg`、`grep`、`awk`、`sed`、`jq`、`file`、`tree`、`less`、`vim`、`nano`、`rsync`。
- 存储和硬件：`lsblk`、`blkid`、`findmnt`、`mount`、`nsenter`、`dmidecode`、`lshw`、`lspci`、`lsusb`、`smartctl`、`modprobe`。
- 数据和脚本：`python3`、`pip3`、`sqlite3`、`openssl`、`ssh`、`git`、`readelf`、`objdump`、`strings`、`zip`、`unzip`、`7z`、`zstd`、`xz`、`bzip2`、`mysql`、`psql`、`mongosh`、`redis-cli`。

### 权限边界

镜像包含工具不代表调试容器自动拥有使用这些工具的权限：

- 抓包和部分网络诊断通常需要 `CAP_NET_RAW`，修改网络配置还需要 `CAP_NET_ADMIN`。
- `strace`、`gdb` 和查看其他容器进程通常需要共享 PID namespace，并可能需要 `CAP_SYS_PTRACE`。
- `mount`、`nsenter`、硬件信息和内核模块命令需要对应的 capability、host namespace 或宿主机设备。
- 不建议为了让命令“都能用”而默认使用 `privileged`；应按一次排障所需的最小权限创建调试容器。
