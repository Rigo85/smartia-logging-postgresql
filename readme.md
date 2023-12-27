

# Pasos para levantar el maestro/réplica en PostgreSQl.
- **Instalar docker**: `https://docs.docker.com/engine/install/ubuntu/`
  - `sudo usermod -aG docker azureuser`
  - `newgrp docker`
- **Crear red**: `docker network create --subnet=172.18.0.0/16 mi-red`
- **Asegurar que existan**: `$HOME/pgdata`, `$HOME/pgdata_replica`.
  - ```bash
    mkdir $HOME/pgdata
    mkdir $HOME/pgdata_replica
    ```
- **Iniciar el servidor maestro**: `docker compose up -d postgres-master`
  - Verificar que el servidor maestro esté funcionando correctamente.
- **Instalar cliente postgres**:
  ```bash
  # buscar/instalar la versión 16
  sudo apt install postgresql-client-common
  sudo apt install postgresql-client-16
  ```
- **Crear un backup del servidor maestro desde el host**:
  - ```bash
    pg_basebackup -h localhost -D ./pgdata_replica -U replicator -P -v -R --slot=replication_slot
    ```
  - Instalar vim en *postgres-replica*, en */var/lib/postgresql/data/postgresql.auto.conf*, actualizar **host** en *primary_conninfo*.
- **Iniciar el servidor réplica**: `docker compose up -d postgres-replica`


# Configuración para limitar el uso de los recursos(por revisar).
Para limitar el uso de CPU y memoria de los contenedores en Docker, puedes utilizar las opciones de configuración de recursos al ejecutar tus contenedores con docker run o dentro de tu archivo docker-compose.yml. Estas configuraciones permiten asignar una cantidad máxima de memoria y CPU que cada contenedor puede utilizar, ayudando a evitar que un servicio acapare la mayoría de los recursos del sistema y afecte el rendimiento de los demás.
```bash
docker run -d \
--name mi-postgres \
-e POSTGRES_PASSWORD=mi_contraseña \
-v /mi/volumen/postgres:/var/lib/postgresql/data \
--memory="2g" \
--cpus="2.0" \
postgres
```


```yaml
version: '3'
services:
  postgres-master:
    image: postgres
    environment:
      POSTGRES_PASSWORD: mi_contraseña
    volumes:
      - /mi/volumen/postgres:/var/lib/postgresql/data
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G

```