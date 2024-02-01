# fluxcp-helm

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

This chart can provide an FluxCP installation on a Kubernetes cluster.

**Homepage:** <https://github.com/mestre8d/charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Filipe Souza | <filipe.souza@mestre8d.com> | <https://github.com/Filipe-Souza> |

## Source Code

* <https://github.com/mestre8d/charts/tree/main/charts/rathena-fluxcp>
* <https://github.com/Filipe-Souza/rathena-fluxcp-docker>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` |  |
| configuration.baseUri | string | `"/"` |  |
| configuration.installerPassword | int | `1234` |  |
| configuration.serverAddress | string | `"localhost"` |  |
| configuration.serverName | string | `"FluxRO"` |  |
| configuration.servers.char_server.host | string | `"127.0.0.1"` |  |
| configuration.servers.char_server.port | int | `5121` |  |
| configuration.servers.databases.config.database | string | `"ragnarok"` |  |
| configuration.servers.databases.config.host | string | `"127.0.0.1"` |  |
| configuration.servers.databases.config.password | string | `"ragnarok"` |  |
| configuration.servers.databases.config.timezone | string | `"+0:00"` |  |
| configuration.servers.databases.config.username | string | `"ragnarok"` |  |
| configuration.servers.databases.log.database | string | `"ragnarok"` |  |
| configuration.servers.databases.log.host | string | `"127.0.0.1"` |  |
| configuration.servers.databases.log.password | string | `"ragnarok"` |  |
| configuration.servers.databases.log.timezone | string | `"+0:00"` |  |
| configuration.servers.databases.log.username | string | `"ragnarok"` |  |
| configuration.servers.databases.web.database | string | `"ragnarok"` |  |
| configuration.servers.databases.web.host | string | `"127.0.0.1"` |  |
| configuration.servers.databases.web.password | string | `"ragnarok"` |  |
| configuration.servers.databases.web.username | string | `"ragnarok"` |  |
| configuration.servers.login_server.host | string | `"127.0.0.1"` |  |
| configuration.servers.login_server.port | int | `6900` |  |
| configuration.servers.map_server.host | string | `"127.0.0.1"` |  |
| configuration.servers.map_server.port | int | `6121` |  |
| image.imagePullPolicy | string | `"Always"` |  |
| image.imagePullSecrets[0].name | string | `"registry-auth"` |  |
| image.name | string | `"ghcr.io/filipe-souza/rathena-fluxcp"` |  |
| image.tag | string | `"v0.0.1"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.ingressClassName | string | `nil` |  |
| ingress.labels | object | `{}` |  |
| ingress.tls | list | `[]` |  |
| labels | object | `{}` |  |
| replicaCount | int | `1` |  |
| service.annotations | object | `{}` |  |
| service.container.port | int | `80` |  |
| service.labels | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| storage.accessModes[0] | string | `"ReadWriteMany"` |  |
| storage.annotations | object | `{}` |  |
| storage.labels | object | `{}` |  |
| storage.size | string | `"10Gi"` |  |
| storage.storageClassName | string | `"local-path"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)