#!/usr/bin/env bash
set -x
# Fetching the release tags from the GitHub API
release_tags=$(curl -s https://api.github.com/repos/tailscale/tailscale/releases |\
  grep '"tag_name":' | \
  sed -n '1,3s/.*"v\([^"]*\)".*/\1/p' | \
  sort -V)
echo $release_tags
docker buildx build --platform linux/amd64 \
    --file ./derper/Dockerfile --push \
    --tag ghcr.io/jimyag/derper:latest \
    --target derper ./derper
# Loop through each release tag and build the Docker image
for tag in $release_tags
do
  docker buildx build --platform linux/amd64 \
    --file ./derper/Dockerfile --push \
    --tag ghcr.io/jimyag/derper:$tag \
    --build-arg VERSION=v$tag \
    --target derper ./derper
done