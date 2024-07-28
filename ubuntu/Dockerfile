FROM ubuntu:22.04

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get install -y curl htop vim less wget lsof telnet jq tmux

ENTRYPOINT [ "/bin/bash" ]