# romm-helm

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

This chart can provide a rommapp/romm installation on a Kubernetes cluster.

**Homepage:** <https://github.com/mestre8d/charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Filipe Souza | <filipe.souza@mestre8d.com> | <https://github.com/Filipe-Souza> |

## Source Code

* <https://github.com/mestre8d/charts/tree/main/charts/romm>
* <https://github.com/rommapp/romm>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` |  |
| image | object | `{"imagePullPolicy":"Always","imagePullSecrets":[],"name":"rommapp/romm","tag":"3.1.0"}` | Container image parameters for the romm server |
| labels | object | `{}` |  |
| replicaCount | int | `1` |  |
| server | object | `{"annotations":{},"configuration":{"config":"","database":{"host":"","name":"","password":"","port":"3306","username":""},"igdbClientId":"","igdbClientSecret":"","initialPassword":"","initialUsername":"admin","mobyApiKey":"","secretKey":""},"ingress":{"annotations":{},"create":false,"hostName":"","ingressClassName":"","labels":{},"path":"/","paths":[],"resourceRootUrl":"","tls":{}},"labels":{},"livenessProbe":{"initialDelaySeconds":30,"periodSeconds":60},"service":{"annotations":{},"create":true,"labels":{},"port":9080,"type":"ClusterIP"}}` | Server configuration block |
| server.configuration | object | `{"config":"","database":{"host":"","name":"","password":"","port":"3306","username":""},"igdbClientId":"","igdbClientSecret":"","initialPassword":"","initialUsername":"admin","mobyApiKey":"","secretKey":""}` | Allows configuring the romm app and also set up some environment credentials here. @bigValue |
| server.configuration.config | string | `""` | Insert here the config.yaml parameters for the romm. |
| server.configuration.database | object | `{"host":"","name":"","password":"","port":"3306","username":""}` | Allows configuring the romm app database credentials. @bigValue |
| server.configuration.database.host | string | `""` | Main database host address |
| server.configuration.database.name | string | `""` | Main database schema name |
| server.configuration.database.password | string | `""` | Main database password |
| server.configuration.database.port | string | `"3306"` | Main database host port |
| server.configuration.database.username | string | `""` | Main database username |
| server.configuration.igdbClientId | string | `""` | The IGDB client ID to be stored on a secret. Should be a text plain value. |
| server.configuration.igdbClientSecret | string | `""` | The IGDB client secret to be stored on a secret. Should be a text plain value. |
| server.configuration.initialPassword | string | `""` | The initial password for the initial user of the romm app. |
| server.configuration.initialUsername | string | `"admin"` | The initial username of the romm app. |
| server.configuration.mobyApiKey | string | `""` | The MobyAPI key to be stored on a secret. Should be a text plain value. |
| server.configuration.secretKey | string | `""` | The secret key for the romm app. You can generate one with the command 'openssl rand -hex 32' |
| server.ingress.create | bool | `false` | Enable/disables the creation of the Ingress |
| server.ingress.ingressClassName | string | `""` | The ingress class name |
| server.ingress.path | string | `"/"` | Default path configuration |
| server.ingress.paths | list | `[]` | Multiple paths configuration. |
| server.livenessProbe.initialDelaySeconds | int | `30` | Delay to start probing the pod |
| server.livenessProbe.periodSeconds | int | `60` | Delay between probes on the pod |
| server.service | object | `{"annotations":{},"create":true,"labels":{},"port":9080,"type":"ClusterIP"}` | Allows controlling the service creation and parameters. |
| server.service.create | bool | `true` | Enable/disables the creation of the service |
| server.service.port | int | `9080` | Port that service will be listening |
| server.service.type | string | `"ClusterIP"` | Type of service. |
| storage.assets.annotations | object | `{}` |  |
| storage.assets.labels | object | `{}` |  |
| storage.assets.persist | bool | `false` | Enable/disable the persistence of assets directory. |
| storage.assets.size | string | `"2G"` | The size of the PV for the assets' directory. |
| storage.assets.storageClassName | string | `""` | The storage class name to be set up on the PV |
| storage.library.annotations | object | `{}` |  |
| storage.library.hostPath | string | `""` | Allows using a node host path to hold the library. The storage.library.persist should be true for this to work. If storage.library.persist is true and this is empty, a PVC will be created. |
| storage.library.labels | object | `{}` |  |
| storage.library.persist | bool | `true` | Enable/disable the persistence of library directory. |
| storage.library.size | string | `"32G"` | The size of the PV for the library directory. Ignored if storage.library.hostPath is used. |
| storage.library.storageClassName | string | `""` | The storage class name to be set up on the PV |
| storage.resources.annotations | object | `{}` |  |
| storage.resources.labels | object | `{}` |  |
| storage.resources.persist | bool | `false` | Enable/disable the persistence of resources data directory. |
| storage.resources.size | string | `"2G"` | The size of the PV for the resources' directory. |
| storage.resources.storageClassName | string | `""` | The storage class name to be set up on the PV |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
