# https://hub.docker.com/r/microsoft/devcontainers-go
FROM mcr.microsoft.com/devcontainers/go:1.24-bookworm

# Update the OpenVPN easy-rsa version here
ARG EASYRSA_VERSION=3.2.2

# Install the latest version from globalsign estserver
RUN go install -v github.com/globalsign/est/cmd/estserver@latest

# Install additional packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssl \
    supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install OpenVPN easy-rsa
RUN mkdir -p /opt/easy-rsa /tmp/easy-rsa && \
    cd /tmp/easy-rsa && \
    wget -q https://github.com/OpenVPN/easy-rsa/releases/download/v${EASYRSA_VERSION}/EasyRSA-${EASYRSA_VERSION}.tgz && \
    tar -xzf EasyRSA-${EASYRSA_VERSION}.tgz --strip-components=1 -C /opt/easy-rsa && \
    ln -s /opt/easy-rsa/easyrsa /usr/local/bin/easyrsa && \
    rm -rf /tmp/easy-rsa

# copy postCreate & supervisord files
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./postCreate.sh /bin/postCreate.sh
RUN chmod +x /bin/postCreate.sh