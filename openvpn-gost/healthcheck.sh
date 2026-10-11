#!/bin/bash
set -euo pipefail
ip -4 route get 1.1.1.1 | grep -q 'dev tun0'
curl --fail --silent --show-error --max-time 10 \
    --proxy "socks5h://127.0.0.1:${GOST_PORT}" \
    "${HEALTHCHECK_URL}" >/dev/null
