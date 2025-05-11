# containers

## noVNC

```bash
docker run --rm --name novnc \
    -p 6080:6080 \
    -e VNC_SERVER=192.168.2.100:5900 \
    ghcr.io/jimyag/novnc:latest
```
