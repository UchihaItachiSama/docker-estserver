#!/bin/bash

set +e

# Set environment variables
direnv allow
eval "$(direnv export bash)"

# Generate CA and server certificates
easyrsa init-pki
easyrsa build-ca
easyrsa --subject-alt-name="DNS:${EASYRSA_SERVER_NAME},IP:${EASYRSA_SERVER_IP}" build-server-full server nopass

# Copy generated CA and server certs for ease of access
mkdir -p certz/server certz/CA
cp pki/issued/server.crt certz/server/server.crt
cp pki/private/server.key certz/server/server.key
cp pki/ca.crt certz/CA/ca.crt
cp pki/private/ca.key certz/CA/ca.key

# Start supervisord 
supervisord -c /etc/supervisor/conf.d/supervisord.conf