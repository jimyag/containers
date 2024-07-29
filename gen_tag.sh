#!/usr/bin/env bash
tag=$(TZ='Asia/Shanghai' date "+%Y-%m-%d-%H-%M-%S")
git tag "$tag"
git push --tags origin "$tag"