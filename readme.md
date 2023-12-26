

# Pasos para levantar el maestro/réplica en PostgreSQl.

- **Crear red**: `docker network create --subnet=172.18.0.0/16 mi-red`
- **Asegurar que existan**: `$HOME/pgdata`, `$HOME/pgdata_replica`, `$HOME/[master|replica]/postgresql.conf`,`$HOME/[master|replica]/pg_hba.conf`.
- **Levantar DB**: `docker compose up`. 

# Configuración para limitar el uso de los recursos.
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