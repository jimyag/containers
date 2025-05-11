FROM alpine:latest AS novnc

RUN set -eux && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache novnc

ENV VNC_SERVER=127.0.0.1:5900
ENV VNC_AUTOCONNECT=true

RUN sed -i "s/'autoconnect', false/'autoconnect', ${VNC_AUTOCONNECT}/" /usr/share/novnc/app/ui.js

WORKDIR /usr/share/novnc

ENTRYPOINT ["sh", "-c"]
CMD ["novnc_server --listen 0.0.0.0:6080 --vnc $VNC_SERVER"]