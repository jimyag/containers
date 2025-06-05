#!/usr/bin/env bash
docker buildx build --platform linux/amd64 \
    --file ./openconnect/Dockerfile --load \
    --tag ghcr.io/jimyag/openconnect:latest \
    ./openconnect
