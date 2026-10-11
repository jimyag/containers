#!/bin/bash
set -euo pipefail
config=/config/client.ovpn
auth=/config/auth.txt
: "${DNS_IP:?Set DNS_IP to the upstream IPv4 DNS address}"
: "${HEALTHCHECK_URL:?Set HEALTHCHECK_URL to the HTTPS endpoint to probe}"
vpn_proto=$(awk '$1 == "proto" {print $2; exit}' "$config")
case "${vpn_proto:-udp}" in
    tcp*) vpn_proto=tcp ;;
    udp*) vpn_proto=udp ;;
    *) echo "Only IPv4 TCP/UDP VPN profiles are supported" >&2; exit 1 ;;
esac
vpn_host=$(awk '$1 == "remote" {print $2; exit}' "$config")
vpn_port=$(awk '$1 == "remote" {print $3; exit}' "$config")
vpn_ip=$(getent ahostsv4 "$vpn_host" | awk 'NR == 1 {print $1}')
gateway=$(ip -4 route show default | awk 'NR == 1 {print $3}')
test -n "$vpn_ip"
test -n "$vpn_port"
test -n "$gateway"

# Replies to proxy clients must return through Docker, outside the full-tunnel VPN.
for route in ${RETURN_ROUTES}; do
    ip -4 route replace "$route" via "$gateway" dev eth0
done

# Only VPN/DNS control traffic and replies to proxy clients may leave on eth0.
iptables -P OUTPUT DROP
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport "$GOST_PORT" -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -d "$vpn_ip" -p "$vpn_proto" --dport "$vpn_port" -j ACCEPT
iptables -A OUTPUT -o eth0 -d "$DNS_IP" -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -o eth0 -d "$DNS_IP" -p tcp --dport 53 -j ACCEPT
ip6tables -P OUTPUT DROP
ip6tables -A OUTPUT -o lo -j ACCEPT

vpn_pid=
gost_pid=
cleanup() {
    trap - EXIT INT TERM
    for pid in "$gost_pid" "$vpn_pid"; do
        if [[ -n "$pid" ]]; then kill "$pid" 2>/dev/null || true; fi
    done
    wait || true
}
trap cleanup EXIT
trap 'exit 143' INT TERM

openvpn --config "$config" --auth-user-pass "$auth" --auth-nocache &
vpn_pid=$!
ready=false
for ((attempt=0; attempt<120; attempt++)); do
    kill -0 "$vpn_pid"
    if ip -4 route get 1.1.1.1 | grep -q 'dev tun0'; then
        ready=true
        break
    fi
    sleep 1
done
if [[ "$ready" != true ]]; then
    echo "VPN route did not become ready" >&2
    exit 1
fi
gost -L=":${GOST_PORT}" &
gost_pid=$!
wait -n "$vpn_pid" "$gost_pid"
