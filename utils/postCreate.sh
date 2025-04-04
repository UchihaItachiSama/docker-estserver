#!/bin/bash

set +e

# Install required packages
echo "[ STAGE-1 ] Installing packages..."
apt-get update && \
apt-get install -y --no-install-recommends \
        supervisor

# Install estserver
echo "[ STAGE-2 ] Installing globalsign estserver..."
go install -v github.com/globalsign/est/cmd/estserver@latest

# Install Easy-RSA
EASYRSA_VERSION=3.2.2
echo "[ STAGE-3 ] Installing Easy-RSA ${EASYRSA_VERSION}..."
mkdir -p /opt/easy-rsa /tmp/easy-rsa && \
wget -q https://github.com/OpenVPN/easy-rsa/releases/download/v${EASYRSA_VERSION}/EasyRSA-${EASYRSA_VERSION}.tgz -O /tmp/easy-rsa/EasyRSA-${EASYRSA_VERSION}.tgz && \
tar -xzf /tmp/easy-rsa/EasyRSA-${EASYRSA_VERSION}.tgz --strip-components=1 -C /opt/easy-rsa && \
ln -sf /opt/easy-rsa/easyrsa /usr/local/bin/easyrsa && \
rm -rf /tmp/easy-rsa

# Ensure supervisor config is in place
echo "[ STAGE-4 ] Copying supervisord config..."
cp /docker-estserver/utils/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set environment variables
echo "[ STAGE-5 ] Setting env vars..."
direnv allow
eval "$(direnv export bash)"

# Generate CA and server certificates
echo "[ STAGE-6 ] Generating CA and Server certs..."
easyrsa init-pki
easyrsa build-ca
easyrsa --subject-alt-name="DNS:${EASYRSA_SERVER_NAME},IP:${EASYRSA_SERVER_IP}" build-server-full server nopass

# Copy generated CA and server certs for ease of access
echo "[ STAGE-7 ] Copying CA and Server certs..."
mkdir -p certz/server certz/CA
cp pki/issued/server.crt certz/server/server.crt
cp pki/private/server.key certz/server/server.key
cp pki/ca.crt certz/CA/ca.crt
cp pki/private/ca.key certz/CA/ca.key

# Start supervisord
echo "[ STAGE-7 ] Starting estserver..."
supervisord -c /etc/supervisor/conf.d/supervisord.conf