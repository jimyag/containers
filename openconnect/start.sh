#!/bin/bash
# 从环境变量获取凭据
LDAP_USER=${LDAP_USER:-'your_username'}
LDAP_PASSWD=${LDAP_PASSWD:-'your_password'}
VPN_SERVER=${VPN_SERVER:-'your_vpn_server'}
GOST_PORT=${GOST_PORT:-53200}

echo "$LDAP_PASSWD" | /usr/sbin/openconnect --user="$LDAP_USER" --config=/root/openconnect.conf $VPN_SERVER
gost -L=":${GOST_PORT}"
