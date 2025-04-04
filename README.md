# docker-estserver

- [docker-estserver](#docker-estserver)
  - [Installation](#installation)
    - [Requirements](#requirements)
  - [Quickstart: devcontainer](#quickstart-devcontainer)
  - [Quickstart: docker compose](#quickstart-docker-compose)
    - [Validate Configuration](#validate-configuration)
    - [Building images](#building-images)
    - [Generate Certificates](#generate-certificates)
    - [Starting the server](#starting-the-server)

This repository helps in deploying the [GlobalSign EST Server](https://github.com/globalsign/est) for Testing purposes only.

## Installation

Clone the repository using Git clone 

```shell
git clone https://github.com/UchihaItachiSama/docker-estserver.git

OR

git clone git@github.com:UchihaItachiSama/docker-estserver.git
```

### Requirements

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Quickstart: devcontainer

Use the following steps to start the project using vscode devcontainer.

## Quickstart: docker compose

Instead of devcontainer, you can also use the regular docker compose as well to deploy and test the estserver using below steps.

### Validate Configuration

- Update and confirm the easyrsa variables in the `vars` and `utils/docker-compose.yaml` files. For more details on the same refer [link](https://github.com/OpenVPN/easy-rsa/blob/master/doc/EasyRSA-Advanced.md#environmental-variables-reference).
- Update and confirm the estserver configuration in `server/server.cfg`

### Building images
- Goto `/docker-estserver/utils/` directory

```shell
cd utils

.
├── Dockerfile
├── docker-compose.yaml
├── estctl.sh
├── gen-certs.sh
├── postCreate.sh
└── supervisord.conf
```

- Build the estserver and easyrsa images

```shell
$ docker compose build

$ docker images
REPOSITORY                           TAG             IMAGE ID       CREATED          SIZE
estserver-img                        latest          1d1ddcebebd4   46 minutes ago   1.43GB
easyrsa-img                          latest          2631c6b30d74   46 minutes ago   1.25GB
```

### Generate Certificates

- Run the following command to generate the CA and Server certificates

```shell
$ docker compose run --rm easyrsa
```

- A successful run will result in certificates files as follows

```shell
certz/
├── CA
│   ├── ca.crt
│   └── ca.key
└── server
    ├── server.crt
    └── server.key
```

- If you have openssl installed you can check the certificates using the `openssl x509 -text -in ../certz/CA/file.crt`

### Starting the server

- Start the server using the following command

```shell
$ docker compose up -d estserver

docker ps -a
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                    NAMES
1368466a2164   estserver-img   "estserver -config /…"   28 seconds ago   Up 27 seconds   0.0.0.0:8443->8443/tcp   est-estserver-1
```

- To check the server logs use the following command

```shell
docker compose logs estserver -f
estserver-1  | 2025-04-04T18:10:17.868824959Z	INFO	estserver/main.go:246	Starting EST server FOR NON-PRODUCTION USE ONLY
```
