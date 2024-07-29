#!/usr/bin/env bash
set -ex
jdk_versions=("1.8.0_411" "1.8.0_111")
jre_versions=("1.8.0_411" "1.8.0_111")

base_url="https://r2.jimyag.com"

for jdk_version in "${jdk_versions[@]}"; do
    dst="jdk-${jdk_version}-linux-x64.tar.gz"
    wget -q "$base_url/${dst}" -O "./java/${dst}"
    tar -xzf "./java/${dst}" -C "./java"
    mv "./java/jdk${jdk_version}" "./java/java"

    docker buildx build --platform linux/amd64 \
        --file ./java/Dockerfile --push \
        --tag ghcr.io/jimyag/jdk:"${jdk_version}" ./java

    rm "./java/${dst}"
    rm -rf "./java/java"
done

for jre_version in "${jre_versions[@]}"; do
    dst="jre-${jre_version}-linux-x64.tar.gz"
    wget -q "$base_url/${dst}" -O "./java/${dst}"
    tar -xzf "./java/${dst}" -C "./java"
    mv "./java/jre${jre_version}" "./java/java"

    docker buildx build --platform linux/amd64 \
        --file ./java/Dockerfile --push \
        --tag ghcr.io/jimyag/jre:"${jre_version}" ./java

    rm "./java/${dst}"
    rm -rf "./java/java"
done
