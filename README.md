# SQL Server Developer Docker Compose

This repository provides a simple Docker Compose setup for running Microsoft SQL Server Developer edition in a container. It spins up an instance of SQL Server 2025, exposing the default port (1433) and persisting data across restarts.

---

## docker-compose.yaml

```yaml
services:
  sqlserverdev:
    image: mcr.microsoft.com/mssql/server:2025-latest
    container_name: sqlserverdev
    ports:
      - "1433:1433"
    environment:
      MSSQL_PID: "Developer"
      ACCEPT_EULA: "Y"
      ACCEPT_EULA_ML: "Y"
      MSSQL_SA_PASSWORD: "1qaz2wsx@@"
      MSSQL_AGENT_ENABLED: "True"
    volumes:
      - sqlserver_data:/var/opt/mssql
    restart: unless-stopped

volumes:
  sqlserver_data:
    driver: local
```

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
  - [Ports](#ports)
  - [Volumes](#volumes)
- [Connecting to SQL Server](#connecting-to-sql-server)
- [Stopping and Removing Containers](#stopping-and-removing-containers)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/) (v20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (v1.29+ or v2+)
- A SQL client tool such as [SQL Server Management Studio](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) or [Azure Data Studio](https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio).

---

## Getting Started

1. **Clone this repository:**

   ```bash
   git clone https://github.com/<your-username>/sqlserver-dev-docker.git
   cd sqlserver-dev-docker
   ```

2. **Review or customize** `docker-compose.yaml` (see [Configuration](#configuration) below).

3. **Launch the stack:**

   ```bash
   docker-compose up -d
   ```

   This will download the `mcr.microsoft.com/mssql/server:2025-latest` image (if not already present), create and start the `sqlserverdev` container.

---

## Usage

- **View logs**:

  ```bash
  docker-compose logs -f sqlserverdev
  ```

- **Execute a command inside the container** (e.g., run `sqlcmd`):

  ```bash
  docker exec -it sqlserverdev /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "1qaz2wsx@@"
  ```

- **Run a one-off migration or script**:

  ```bash
  docker exec -i sqlserverdev /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "1qaz2wsx@@" \
    -i path/to/your/script.sql
  ```

---

## Configuration

### Environment Variables

| Variable              | Description                                       | Default / Example |
| --------------------- | ------------------------------------------------- | ----------------- |
| `MSSQL_PID`           | SQL Server edition (`Developer`, `Express`, etc.) | `Developer`       |
| `ACCEPT_EULA`         | Accept the SQL Server license agreement           | `Y`               |
| `ACCEPT_EULA_ML`      | Accept the Machine Learning Services EULA         | `Y`               |
| `MSSQL_SA_PASSWORD`   | Strong password for the `sa` user                 | `1qaz2wsx@@`      |
| `MSSQL_AGENT_ENABLED` | Enable SQL Server Agent (True/False)              | `True`            |

> **Warning:** Never commit real credentials to a public repo. Consider using a `.env` file or Docker secrets for production.

### Ports

| Host Port | Container Port | Description            |
| --------- | -------------- | ---------------------- |
| `1433`    | `1433`         | Default SQL Server TCP |

### Volumes

| Name             | Container Path   | Purpose                       |
| ---------------- | ---------------- | ----------------------------- |
| `sqlserver_data` | `/var/opt/mssql` | Persist database files & logs |

---

## Connecting to SQL Server

Use your favorite SQL client to connect:

- **Server:** `localhost,1433`
- **Login:** `sa`
- **Password:** `1qaz2wsx@@`

Example connection string (ADO.NET / .NET):

```text
Server=localhost,1433;Database=master;User Id=sa;Password=1qaz2wsx@@;
```

---

## Stopping and Removing Containers

- **Stop containers:**

  ```bash
  docker-compose down
  ```

  This stops and removes containers but preserves volumes.

- **Remove volumes as well:**

  ```bash
  docker-compose down -v
  ```

  ⚠️ This will delete all persisted data in `sqlserver_data`.

---

## Troubleshooting

- **Container fails to start**

  - Check logs: `docker-compose logs sqlserverdev`
  - Ensure your host port `1433` is not already in use.
  - Verify your `sa` password meets SQL Server’s complexity requirements.

- **Cannot connect**

  - Confirm the container’s health:
    ```bash
    docker inspect sqlserverdev --format='{{.State.Health.Status}}'
    ```
  - Make sure your firewall allows traffic on port 1433.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

> *Happy coding! 🎉*
