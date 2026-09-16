# Ubuntu

基于 Ubuntu 22.04 的通用工具镜像，预装以下常用命令：

- `curl`、`wget`、`telnet`
- `htop`、`lsof`、`tmux`
- `vim`、`less`、`jq`

## 使用

```bash
docker run --rm -it ghcr.io/jimyag/ubuntu:22.04
```

也可以使用滚动标签：

```bash
docker run --rm -it ghcr.io/jimyag/ubuntu:latest
```

## 构建

该镜像当前只构建 `linux/amd64`：

```bash
./ubuntu/build.sh
```

Dockerfile 会将 Ubuntu APT 源切换为中科大镜像，并在构建过程中执行系统升级。镜像标签为 `22.04` 和 `latest`。
