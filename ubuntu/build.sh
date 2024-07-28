#!/usr/bin/env bash
docker buildx build --platform linux/amd64 \
    --file ./ubuntu/Dockerfile --push \
    --tag ghcr.io/jimyag/ubuntu:22.04 \
    --tag ghcr.io/jimyag/ubuntu:latest \
    ./ubuntu
