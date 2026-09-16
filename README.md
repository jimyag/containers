# Containers

这个仓库维护几个可独立构建和发布的 Docker 镜像。每个目录包含自己的构建文件和使用说明。

| 组件 | 用途 | 镜像 | 文档 |
| --- | --- | --- | --- |
| `ubuntu` | 带常用排障工具的 Ubuntu 22.04 基础镜像 | `ghcr.io/jimyag/ubuntu:22.04`、`ghcr.io/jimyag/ubuntu:latest` | [ubuntu/README.md](ubuntu/README.md) |
| `novnc` | 通过浏览器访问 VNC 服务 | `ghcr.io/jimyag/novnc:latest` | [novnc/README.md](novnc/README.md) |
| `openconnect` | OpenConnect VPN 和 gost SOCKS5 代理 | `ghcr.io/jimyag/openconnect:latest` | [openconnect/README.md](openconnect/README.md) |
| `debug` | Kubernetes 临时调试工具箱 | `ghcr.io/jimyag/debug:latest` | [debug/README.md](debug/README.md) |

## 构建和发布

每个组件目录都有一个 `build.sh`。从仓库根目录执行对应脚本即可构建并推送镜像；镜像发布工作流由 Git tag push 触发，详见 [.github/workflows/image.yaml](.github/workflows/image.yaml)。
