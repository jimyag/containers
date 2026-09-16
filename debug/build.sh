#!/usr/bin/env bash

set -euo pipefail

docker buildx build --platform linux/amd64,linux/arm64 \
    --file ./debug/Dockerfile --push \
    --tag ghcr.io/jimyag/debug:latest \
    ./debug
