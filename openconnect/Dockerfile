FROM alpine:latest AS download

WORKDIR /root

RUN apk update && \
    apk add wget tar

RUN wget https://github.com/ginuerzh/gost/releases/download/v2.12.0/gost_2.12.0_linux_amd64.tar.gz && \
    tar -xzf gost_2.12.0_linux_amd64.tar.gz

FROM ubuntu:24.04

WORKDIR /root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y openconnect curl

COPY --from=download /root/gost /usr/local/bin/gost
COPY openconnect.conf ./
COPY start.sh ./

ENTRYPOINT ["/bin/bash", "-c", "./start.sh"]
