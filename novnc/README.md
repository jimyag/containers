# noVNC

基于 Alpine 的 noVNC 镜像，用浏览器访问 VNC 服务。

## 使用

```bash
docker run --rm --name novnc \
    -p 6080:6080 \
    -e VNC_SERVER=192.168.2.100:5900 \
    ghcr.io/jimyag/novnc:latest
```

然后打开 <http://localhost:6080>。

| 环境变量 | 默认值 | 说明 |
| --- | --- | --- |
| `VNC_SERVER` | `127.0.0.1:5900` | VNC 服务地址和端口 |

容器监听 `0.0.0.0:6080`，镜像默认开启 noVNC 自动连接。

## 构建

该镜像构建 `linux/amd64` 和 `linux/arm64`：

```bash
./novnc/build.sh
```
