FROM debian:13.7-slim@sha256:a29215f6a35e51e22adffa17f89e9d2ef06214e64a2bad10d765c46aea49f11f AS build
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential pkgconf ca-certificates curl libssl-dev liblzo2-dev liblz4-dev libcap-ng-dev \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /build
RUN curl -fsSL https://github.com/OpenVPN/openvpn/releases/download/v2.7.8/openvpn-2.7.8.tar.gz -o openvpn.tar.gz \
    && echo 'c070d1d2440b5a6fca6c2c68645c98cd492116ac36ef4f0946177115532c8e36  openvpn.tar.gz' | sha256sum -c - \
    && tar -xzf openvpn.tar.gz \
    && cd openvpn-2.7.8 \
    && ./configure --disable-dco --disable-plugin-auth-pam \
    && make -j"$(nproc)" \
    && strip src/openvpn/openvpn
RUN curl -fsSL https://github.com/go-gost/gost/releases/download/v3.3.0/gost_3.3.0_linux_amd64.tar.gz -o gost.tar.gz \
    && echo '676fb7f78d267b6ae73df719c0c7f2b565dde7147da935cfafbc1e1da558b6d5  gost.tar.gz' | sha256sum -c - \
    && tar -xzf gost.tar.gz gost

FROM debian:13.7-slim@sha256:a29215f6a35e51e22adffa17f89e9d2ef06214e64a2bad10d765c46aea49f11f
LABEL org.opencontainers.image.source="https://github.com/jimyag/containers"
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl iproute2 iptables libssl3t64 liblzo2-2 liblz4-1 libcap-ng0 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /build/openvpn-2.7.8/src/openvpn/openvpn /usr/local/sbin/openvpn
COPY --from=build /build/gost /usr/local/bin/gost
COPY --chmod=755 entrypoint.sh healthcheck.sh /usr/local/bin/
ENV GOST_PORT=53200 RETURN_ROUTES="" DNS_IP="" HEALTHCHECK_URL=""
EXPOSE 53200/tcp
HEALTHCHECK --interval=30s --timeout=15s --start-period=120s --retries=3 CMD ["/usr/local/bin/healthcheck.sh"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
