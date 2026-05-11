# Bigcapital Helm Chart

> [!IMPORTANT]
> This helm chart uses custom container images available at [mestre8d/bigcapital-docker](https://github.com/orgs/mestre8d/packages/container/package/bigcapital-docker) registry, but you can build your own based on the container recipe from the original repository.

A Helm chart for deploying [Bigcapital](https://github.com/bigcapitalhq/bigcapital) on Kubernetes. The chart packages the upstream Docker images for the `webapp`, `server`, `gotenberg` (PDF rendering), MariaDB, and Redis into a single Pod, and renders an `app-env` Secret containing the server's environment configuration.

## Quick start

```bash
helm install my-bigcapital ./bigcapital
```

The default values run a self-contained stack: in-cluster MariaDB and Redis, with PVCs for persistent storage. The `JWT_SECRET` (`APP_JWT_SECRET`) is generated automatically on first install and persisted across `helm upgrade` calls via a `lookup` of the existing Secret.

## Configuration

All tunables live in `values.yaml`. The most relevant sections are documented below.

### `server`

| Key | Default | Description |
|---|---|---|
| `server.secret_string` | `""` | If set, used verbatim as `APP_JWT_SECRET` in the rendered Secret. If empty, the chart reuses the existing in-cluster value (when present) or generates a fresh 64-character random string on first install. |
| `server.image.*` | `docker.io/bigcapitalhq/server:latest` | Server container image. |
| `server.service.port` | `3000` | Port the server listens on inside the Pod. |

### `database` — in-cluster MariaDB

By default the chart runs MariaDB as a sidecar container in the same Pod, with a PVC mounted at `/var/lib/mysql`. Credentials are sourced from `database.credentials.*` and used both to initialize the MariaDB container (`MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`) and to populate the server's `DB_*` environment.

| Key | Default | Description |
|---|---|---|
| `database.enabled` | `true` | Render the in-cluster MariaDB container and its PVC. |
| `database.credentials.host` | `""` | Leave empty to default to the chart's `fullname` (in-cluster Pod hostname). |
| `database.credentials.port` | `3306` | Port the in-cluster MariaDB listens on. Also set as `DB_PORT` in the Secret. |
| `database.credentials.user` | `"bigcapital"` | MySQL user the bigcapital server connects as. |
| `database.credentials.password` | `"bigcapital"` | Password for the above user. **Override in production.** |
| `database.credentials.rootPassword` | `"root"` | MySQL root password used to bootstrap the MariaDB container. **Override in production.** |
| `database.credentials.systemDbName` | `"bigcapital_system"` | The "system" database that holds the catalog of tenants. Per-tenant databases are created dynamically by the server as `bigcapital_tenant_<organizationId>`. |

### `database.external` — external database

To use an external MySQL/MariaDB server instead of the bundled MariaDB, set `database.external.enabled: true`. When enabled:

- The in-cluster MariaDB container, its PVC, and its PV are NOT rendered (`database.enabled` is implicitly bypassed for those resources).
- `host`, `user`, `password`, and `systemDbName` are validated at render time — `helm install` / `helm upgrade` will fail with a clear message if any are missing.
- The values override `database.credentials.*` in the rendered `app-env` Secret.

| Key | Default | Description |
|---|---|---|
| `database.external.enabled` | `false` | Use an external database instead of the in-cluster MariaDB. |
| `database.external.host` | `""` | **Required when enabled.** Hostname of the external database server. |
| `database.external.port` | `3306` | Port of the external database server. |
| `database.external.user` | `""` | **Required when enabled.** MySQL user the bigcapital server connects as. See "Required privileges" below. |
| `database.external.password` | `""` | **Required when enabled.** Password for the above user. |
| `database.external.rootPassword` | `""` | Optional. Currently not consumed by the bigcapital server itself. |
| `database.external.systemDbName` | `""` | **Required when enabled.** Name of the system database. Must already exist on the external server. |

#### Required privileges for the bigcapital DB user

The bigcapital server **creates and drops tenant databases at runtime** when an organization is created or deleted. Specifically:

- It issues `CREATE DATABASE bigcapital_tenant_<organizationId>` against the system Knex connection.
- It issues `DROP DATABASE IF EXISTS bigcapital_tenant_<organizationId>` on tenant teardown.

Therefore the user configured in `database.external.user` (or `database.credentials.user`) must have at minimum:

- `CREATE` and `DROP` privileges at the server level (these cannot be scoped per-database in MySQL).
- `SELECT` on `INFORMATION_SCHEMA` (typically granted by default).
- All standard DML/DDL privileges on the system database and on the `bigcapital\_tenant\_%` pattern.

The simplest grant matching upstream's expectations is:

```sql
CREATE USER 'bigcapital'@'%' IDENTIFIED BY '<strong-password>';
GRANT ALL PRIVILEGES ON *.* TO 'bigcapital'@'%';
FLUSH PRIVILEGES;
```

A more restrictive grant that still works:

```sql
CREATE USER 'bigcapital'@'%' IDENTIFIED BY '<strong-password>';
GRANT CREATE, DROP ON *.* TO 'bigcapital'@'%';
GRANT ALL PRIVILEGES ON `bigcapital\_%`.* TO 'bigcapital'@'%';
FLUSH PRIVILEGES;
```

The `systemDbName` database (default `bigcapital_system`) must exist before the server starts; the chart does not create it on the external server.

### Why `tenantDbPrefix` and `*_DB_CHARSET` are not exposed

The chart deliberately does NOT expose two upstream env vars from `.env.example`:

- **`TENANT_DB_NAME_PERFIX`** (the typo is upstream's, not ours). On the upstream `develop` branch, `TenantDBManager` honors this prefix when issuing `CREATE DATABASE`, but `TenancyDB.module.ts` hardcodes `bigcapital_tenant_${organizationId}` for runtime Knex connections. Changing the prefix creates databases the application then cannot connect to. We leave it at the upstream default.
- **`DB_CHARSET`, `SYSTEM_DB_CHARSET`, `TENANT_DB_CHARSET`**. The Knex `charset` is hardcoded to `'utf8'` in both `SystemDB.module.ts` and `TenancyDB.module.ts`. Setting these env vars has no effect.

If upstream fixes these issues, the chart can expose the corresponding values in a future version.

### `redis`, `gotenberg`, `webapp`

These follow the same pattern: `image`, `service`, and (for redis/gotenberg) `storage` blocks. See `values.yaml` for the full surface.

## How `app-env` is rendered

The chart renders a Kubernetes Secret named `app-env` from `templates/secret.yaml`. The bigcapital `server` container consumes it via `envFrom.secretRef`, so every key becomes an environment variable. The Secret is also where the auto-generated `APP_JWT_SECRET` lives.

The JWT secret resolution order is:

1. `.Values.server.secret_string` if set (operator-provided).
2. The existing `APP_JWT_SECRET` from the in-cluster `app-env` Secret (preserved across `helm upgrade` via `lookup`).
3. A freshly generated 64-character `randAlphaNum` string (only on first install).

Note: `helm template` and `helm install --dry-run` (without `--dry-run=server`) will appear to generate a fresh random secret each time because `lookup` returns an empty map outside of cluster-applied operations. Real `helm install`/`upgrade` calls against a cluster reuse the existing value as expected.

## Caveats

- **All services run in a single Pod.** This chart packages every component (webapp, server, gotenberg, MariaDB, Redis) into one Deployment with `replicaCount: 1`. Scaling out, splitting components into separate Deployments/StatefulSets, or running HA databases is out of scope.
- **PV/PVC storage uses `hostPath` by default** (see `templates/pv.yaml`). For multi-node clusters or production, override `storageClass` on each component to a real CSI-backed class.
- **Override defaults in production.** `database.credentials.password`, `database.credentials.rootPassword`, and `JWT_SECRET` (in the rendered Secret) all ship with weak placeholder values.
