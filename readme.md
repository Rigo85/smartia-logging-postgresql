# Pasos para levantar PostgreSQl + Solr.

- **Instalar docker**: `https://docs.docker.com/engine/install/ubuntu/`
    - `sudo usermod -aG docker azureuser`
    - `newgrp docker`
- **Crear red**: `docker network create --subnet=172.18.0.0/16 mi-red`
- **Asegurar que existan**: `$HOME/pgdata`, `$HOME/solrdata`.
  ```bash
    mkdir $HOME/pgdata
    mkdir $HOME/solrdata
    ```
- **Iniciar el servidor maestro**: `docker compose up -d postgres-master`
    - Verificar que el servidor maestro esté funcionando correctamente.
- **Instalar cliente postgres**:
  ```bash
  # buscar/instalar la versión 16
  sudo apt install postgresql-client-common
  sudo apt install postgresql-client-16
  ```
- **Iniciar el servidor solr**:
    - `sudo chown -R 8983:8983 /home/azureuser/solrdata`
    - `sudo chmod -R 755 solr-config/conf`
    - `sudo chmod 644 solr-config/conf/schema.xml`
    - `sudo chmod 644 solr-config/conf/solrconfig.xml`
    - `sudo chown -R 8983:8983 solr-config/conf`
    - `docker compose up -d mi-solr`
    - Iniciar sesión:
        - usuario: *solr*.
        - contraseña: *SolrRocks*.
    - Entras al contenedor y actualizas los permisos de *security.json*:
      ```bash
        docker exec -u 0 -ti solr /bin/bash
        chown -R solr:solr /var/solr/data/security.json
      ```
    - Luego cambiar la contraseña.

# Configuración para limitar el uso de los recursos(por revisar).

Para limitar el uso de CPU y memoria de los contenedores en Docker, puedes utilizar las opciones de configuración de
recursos al ejecutar tus contenedores con docker run o dentro de tu archivo docker-compose.yml. Estas configuraciones
permiten asignar una cantidad máxima de memoria y CPU que cada contenedor puede utilizar, ayudando a evitar que un
servicio acapare la mayoría de los recursos del sistema y afecte el rendimiento de los demás.

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