#!/usr/bin/env bash
docker buildx build --platform linux/amd64 \
    --file ./ubuntu/Dockerfile --push \
    --tag ghcr.io/jimyag/ubuntu:latest \
    --tag ghcr.io/jimyag/derper:0.0.1 \
    ./ubuntu