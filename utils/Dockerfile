FROM golang:1.24-bookworm AS easyrsa-img
ARG EASYRSA_VERSION=3.2.2
RUN mkdir -p /opt/easy-rsa /tmp/easy-rsa && \
    wget -q https://github.com/OpenVPN/easy-rsa/releases/download/v${EASYRSA_VERSION}/EasyRSA-${EASYRSA_VERSION}.tgz -O /tmp/easy-rsa/EasyRSA-${EASYRSA_VERSION}.tgz && \
    tar -xzf /tmp/easy-rsa/EasyRSA-${EASYRSA_VERSION}.tgz --strip-components=1 -C /opt/easy-rsa && \
    ln -sf /opt/easy-rsa/easyrsa /usr/local/bin/easyrsa && \
    rm -rf /tmp/easy-rsa

FROM golang:1.24 AS estserver-img
RUN go install -v github.com/globalsign/est/cmd/estserver@latest
EXPOSE 8443
CMD ["estserver"]