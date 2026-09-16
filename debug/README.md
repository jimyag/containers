# debug

面向 Kubernetes 临时排障的工具箱镜像，适合配合 Ephemeral Container 使用。镜像包含网络、进程、文件系统、存储、调试器、硬件信息、Python、SQLite 和常见数据库客户端。

MongoDB 客户端使用官方 `mongosh`。进入调试容器后可以直接运行：

```bash
mongosh --host <host> --port <port>
```

## 使用

直接调试指定 Pod：

```bash
kubectl debug -n production pod/web-xxx \
    -it \
    --image=ghcr.io/jimyag/debug:latest \
    --target=app \
    --container=debug \
    -- bash
```

按 label 选择唯一的 Running Pod 后再注入调试容器：

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

## 工具

- 网络：`ip`、`ss`、`ping`、`arping`、`tracepath`、`traceroute`、`mtr`、`dig`、`nslookup`、`curl`、`wget`、`nc`、`socat`、`tcpdump`、`nmap`、`ethtool`、`conntrack`、`telnet`。
- 进程和系统：`ps`、`top`、`htop`、`pgrep`、`pkill`、`pstree`、`fuser`、`lsof`、`free`、`vmstat`、`iostat`、`pidstat`、`strace`、`ltrace`、`gdb`。
- 文件和文本：`find`、`fd`、`rg`、`grep`、`awk`、`sed`、`jq`、`file`、`tree`、`less`、`vim`、`nano`、`rsync`。
- 存储和硬件：`lsblk`、`blkid`、`findmnt`、`mount`、`nsenter`、`dmidecode`、`lshw`、`lspci`、`lsusb`、`smartctl`、`modprobe`。
- 数据和脚本：`python3`、`pip3`、`sqlite3`、`openssl`、`ssh`、`git`、`readelf`、`objdump`、`strings`、`zip`、`unzip`、`7z`、`zstd`、`xz`、`bzip2`、`mysql`、`psql`、`mongosh`、`redis-cli`。

## 权限边界

镜像包含工具不代表调试容器自动拥有使用这些工具的权限：

- 抓包和部分网络诊断通常需要 `CAP_NET_RAW`，修改网络配置还需要 `CAP_NET_ADMIN`。
- `strace`、`gdb` 和查看其他容器进程通常需要共享 PID namespace，并可能需要 `CAP_SYS_PTRACE`。
- `mount`、`nsenter`、硬件信息和内核模块命令需要对应的 capability、host namespace 或宿主机设备。
- 不要为了让命令“都能用”而默认使用 `privileged`；应按一次排障所需的最小权限创建调试容器。

## 构建

该镜像构建 `linux/amd64` 和 `linux/arm64`：

```bash
./debug/build.sh
```
