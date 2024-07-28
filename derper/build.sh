#!/usr/bin/env bash
docker buildx build --platform linux/amd64 \
    --file ./derper/Dockerfile --push \
    --tag ghcr.io/jimyag/derper:latest \
    --tag ghcr.io/jimyag/derper:0.0.1 \
    ./derper