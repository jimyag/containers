#!/usr/bin/env bash
set -ex

docker buildx build --platform linux/amd64,linux/arm64\
    --file ./novnc/Dockerfile --push \
    --tag ghcr.io/jimyag/novnc:latest \
    ./novnc
