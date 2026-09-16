# 面向 Kubernetes 临时调试的工具箱镜像。
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# mongosh 使用 MongoDB 官方下载包；按架构选择对应的 deb 并固定校验值。
ARG MONGOSH_VERSION=2.10.0
ARG TARGETARCH

# 工具按排障场景分组，避免依赖应用容器本身是否带有诊断命令。
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        bash \
        bash-completion \
        binutils \
        bzip2 \
        ca-certificates \
        cifs-utils \
        conntrack \
        coreutils \
        curl \
        diffutils \
        dnsutils \
        dmidecode \
        ethtool \
        fd-find \
        file \
        findutils \
        fzf \
        gawk \
        git \
        gdb \
        grep \
        htop \
        iproute2 \
        iputils-arping \
        iputils-ping \
        iputils-tracepath \
        jq \
        kmod \
        less \
        libcap2-bin \
        lshw \
        lsof \
        ltrace \
        mariadb-client \
        mtr-tiny \
        nano \
        netcat-openbsd \
        nfs-common \
        nmap \
        openssh-client \
        openssl \
        p7zip-full \
        patch \
        pciutils \
        perl \
        psmisc \
        procps \
        postgresql-client \
        python3 \
        python3-pip \
        python3-venv \
        redis-tools \
        ripgrep \
        rsync \
        sed \
        smartmontools \
        socat \
        sqlite3 \
        strace \
        sysstat \
        tcpdump \
        telnet \
        tmux \
        traceroute \
        tree \
        unzip \
        util-linux \
        vim-tiny \
        wget \
        xz-utils \
        zip \
        zstd && \
    case "${TARGETARCH}" in \
        amd64) \
            mongosh_arch=amd64; \
            mongosh_sha256=00d75b8aee343c52a84c7a728008d45f670aa5fd222089e4a71e59f4a79380b1; \
            ;; \
        arm64) \
            mongosh_arch=arm64; \
            mongosh_sha256=cde31e5ab11c96136bcce635d57704895a0a591d87138559265725c9e8855e68; \
            ;; \
        *) \
            echo "unsupported TARGETARCH: ${TARGETARCH}" >&2 \
            exit 1 \
            ;; \
    esac && \
    curl --fail --silent --show-error --location --retry 3 \
        --output /tmp/mongodb-mongosh.deb \
        "https://downloads.mongodb.com/compass/mongodb-mongosh_${MONGOSH_VERSION}_${mongosh_arch}.deb" && \
    echo "${mongosh_sha256}  /tmp/mongodb-mongosh.deb" | sha256sum --check --strict - && \
    apt-get install --yes --no-install-recommends /tmp/mongodb-mongosh.deb && \
    ln -s /usr/bin/fdfind /usr/local/bin/fd && \
    rm -f /tmp/mongodb-mongosh.deb && \
    rm -rf /var/lib/apt/lists/*

# 不设置 ENTRYPOINT，便于 kubectl debug -- bash -lc '...' 覆盖默认命令。
CMD ["/bin/bash"]
