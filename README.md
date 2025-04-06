# docker-estserver

- [docker-estserver](#docker-estserver)
  - [Overview](#overview)
    - [Requirements](#requirements)
  - [Quickstart: dev container](#quickstart-dev-container)
    - [Validate configuration](#validate-configuration)
    - [Starting the server](#starting-the-server)
  - [Quickstart: docker compose](#quickstart-docker-compose)
    - [Validate configuration](#validate-configuration-1)
    - [Building images](#building-images)
    - [Generate certificates](#generate-certificates)
    - [Starting the server](#starting-the-server-1)

## Overview

This repository helps you deploy the [GlobalSign EST Server](https://github.com/globalsign/est) for **TESTING purposes only**. You can deploy the EST server using [dev container](#quickstart-dev-container) or via [docker compose](#quickstart-docker-compose) with a few additional steps.

### Requirements

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Quickstart: dev container

Use the following steps to launch the project using VS Code Dev Containers extension.

- Open the cloned project folder in VS Code.

### Validate configuration

- Update and verify the easyrsa variables in the `vars` and `.envrc` files. For more details on the same refer [link](https://github.com/OpenVPN/easy-rsa/blob/master/doc/EasyRSA-Advanced.md#environmental-variables-reference).

### Starting the server

- Use the `Dev Containers: Reopen in Container` command from the Command Palette.
- The VS Code window will reload and start building the dev container. A progress notification provides status updates. After the build completes, VS Code will automatically connect to the container.
- Wait for the `postCreate.sh` to finish, which will generate the certificates and start the estserver using supervisord.
- Verify the certificates are generated under the `certz/` directory.
- Verify the server is up and running and check the logs using the following commands:

```shell
$ bash utils/estctl.sh help
Usage: utils/estctl.sh [command]

Commands:
  status        Show supervisor status of all services
  log           Show contents of EST server log
  tail          Tail EST server logs using supervisorctl
  restart       Restart the estserver process via Supervisor
  help          Show this help message

$ bash utils/estctl.sh status
estserver                        RUNNING   pid 3141, uptime 0:00:19

$ bash utils/estctl.sh tail
==> Press Ctrl-C to exit <==
2025-04-06T15:02:45.756962585Z  INFO    estserver/main.go:246   Starting EST server FOR NON-PRODUCTION USE ONLY
```

## Quickstart: docker compose

If you prefer not to use dev containers, you can start the EST server using Docker Compose with the following steps.

### Validate configuration

- Update and confirm the easyrsa variables in the `vars` and `utils/docker-compose.yaml` files. For more details on the same refer [link](https://github.com/OpenVPN/easy-rsa/blob/master/doc/EasyRSA-Advanced.md#environmental-variables-reference).
- Update and confirm the estserver configuration in `server/server.cfg`

### Building images

- Goto `/docker-estserver/utils/` directory and build the estserver and easyrsa images

```shell
$ cd utils
$ docker compose build

$ docker images
REPOSITORY                           TAG             IMAGE ID       CREATED          SIZE
estserver-img                        latest          1d1ddcebebd4   46 minutes ago   1.43GB
easyrsa-img                          latest          2631c6b30d74   46 minutes ago   1.25GB
```

### Generate certificates

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

- If you have openssl installed you can check the certificates using the `openssl x509 -text -in ../certz/CA/file.crt` or using the vscode extension `jlcs-es.x509-parser`

### Starting the server

- Start the server using the following command

```shell
$ docker compose up -d estserver

$ docker ps -a
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                    NAMES
1368466a2164   estserver-img   "estserver -config /…"   28 seconds ago   Up 27 seconds   0.0.0.0:8443->8443/tcp   est-estserver-1
```

- To check the server logs use the following command

```shell
docker compose logs estserver -f
estserver-1  | 2025-04-04T18:10:17.868824959Z	INFO	estserver/main.go:246	Starting EST server FOR NON-PRODUCTION USE ONLY
```
