#!/usr/bin/env bash
set -euo pipefail
docker buildx build --platform linux/amd64 \
    --file ./openvpn-gost/Dockerfile --push \
    --tag ghcr.io/jimyag/openvpn-gost:2.7.8-gost3.3.0 \
    --tag ghcr.io/jimyag/openvpn-gost:latest \
    ./openvpn-gost
