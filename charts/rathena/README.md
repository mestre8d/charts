# rathena-helm

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

This chart can provide an rAthena emulator installation on a Kubernetes cluster.

**Homepage:** <https://github.com/mestre8d/charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Filipe Souza | <filipe.souza@mestre8d.com> | <https://github.com/Filipe-Souza> |

## Source Code

* <https://github.com/mestre8d/charts/tree/main/charts/rathena>
* <https://github.com/Filipe-Souza/rathena-docker>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| databases.log.host | string | `"127.0.0.1"` | Log database host address |
| databases.log.name | string | `"log"` | Log database schema name |
| databases.log.password | string | `"ragnarok"` | Log database password |
| databases.log.port | string | `"3306"` | Log database host port |
| databases.log.username | string | `"ragnarok"` | Log database username |
| databases.main.host | string | `"127.0.0.1"` | Main database host address |
| databases.main.name | string | `"ragnarok"` | Main database schema name |
| databases.main.password | string | `"ragnarok"` | Main database password |
| databases.main.port | string | `"3306"` | Main database host port |
| databases.main.username | string | `"ragnarok"` | Main database username |
| image.imagePullPolicy | string | `"Always"` |  |
| image.imagePullSecrets[0].name | string | `"registry-auth"` |  |
| image.name | string | `"ghcr.io/filipe-souza/rathena"` |  |
| image.tag | string | `"v0.0.1-alpine"` |  |
| namespace | string | `"rathena"` |  |
| replicaCount | int | `1` |  |
| servers.annotations | object | `{}` |  |
| servers.charServer.livenessProbe.initialDelaySeconds | int | `30` | Delay to start probing the pod |
| servers.charServer.livenessProbe.periodSeconds | int | `60` | Delay between probes on the pod |
| servers.charServer.replicas | int | `1` | Number of replicas of this pod |
| servers.charServer.service.create | bool | `true` | Enable/disables the creation of the service |
| servers.charServer.service.port | int | `6121` | Port that service will be listening |
| servers.charServer.service.type | string | `"ClusterIP"` | Type of service. |
| servers.globalName | string | `"rAthena"` | Sets the server_name into the char_conf.txt |
| servers.interServer | object | `{"auth":{"passwd":"p1","userid":"s1"}}` | Configures the credentials to be stored into the config files for the inter-server authentication. |
| servers.labels | object | `{}` |  |
| servers.loginServer.livenessProbe.initialDelaySeconds | int | `15` | Delay to start probing the pod |
| servers.loginServer.livenessProbe.periodSeconds | int | `60` | Delay between probes on the pod |
| servers.loginServer.md5Password | string | `"no"` | Set this value to yes if going to use MySQL 8.0 |
| servers.loginServer.replicas | int | `1` | Number of replicas of this pod |
| servers.loginServer.service.create | bool | `true` | Enable/disables the creation of the service |
| servers.loginServer.service.port | int | `6900` | Port that service will be listening |
| servers.loginServer.service.type | string | `"ClusterIP"` | Type of service. |
| servers.mapServer.livenessProbe.initialDelaySeconds | int | `30` | Delay to start probing the pod |
| servers.mapServer.livenessProbe.periodSeconds | int | `60` | Delay between probes on the pod |
| servers.mapServer.replicas | int | `1` | Number of replicas of this pod |
| servers.mapServer.service.create | bool | `true` | Enable/disables the creation of the service |
| servers.mapServer.service.port | int | `5121` | Port that service will be listening |
| servers.mapServer.service.type | string | `"ClusterIP"` | Type of service. |
| servers.proxyServer.enable | bool | `true` | Enables the websocket proxy service, allowing the usage of roBrowser clients. |
| servers.proxyServer.image.imagePullPolicy | string | `"Always"` |  |
| servers.proxyServer.image.name | string | `"ghcr.io/filipe-souza/rathena"` |  |
| servers.proxyServer.image.tag | string | `"wsproxy"` |  |
| servers.proxyServer.livenessProbe.initialDelaySeconds | int | `30` | Delay to start probing the pod |
| servers.proxyServer.livenessProbe.periodSeconds | int | `60` | Delay between probes on the pod |
| servers.proxyServer.replicas | int | `1` | Number of replicas of this pod |
| servers.proxyServer.service.create | bool | `true` | Enable/disables the creation of the service |
| servers.proxyServer.service.port | int | `5999` | Port that service will be listening |
| servers.proxyServer.service.type | string | `"ClusterIP"` | Type of service. |
| servers.webServer.enable | bool | `false` |  |
| servers.webServer.livenessProbe.initialDelaySeconds | int | `30` | Delay to start probing the pod |
| servers.webServer.livenessProbe.periodSeconds | int | `60` | Delay between probes on the pod |
| servers.webServer.replicas | int | `1` | Number of replicas of this pod |
| servers.webServer.service.create | bool | `true` | Enable/disables the creation of the service |
| servers.webServer.service.port | int | `8888` | Port that service will be listening |
| servers.webServer.service.type | string | `"ClusterIP"` | Type of service. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
