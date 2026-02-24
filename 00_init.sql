create database smartia_logging;

\c smartia_logging

-- Crear una tabla para almacenar logs
CREATE TABLE smartia_logs (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    data TEXT not null,
    source VARCHAR(255) not null,
    hostname VARCHAR(255) not null,
    appname VARCHAR(255) not null,
    isindexed BOOLEAN DEFAULT false
);

-- Crear índices
CREATE INDEX logs_timestamp_idx ON smartia_logs (timestamp);
CREATE INDEX logs_source_idx ON smartia_logs (source);
CREATE INDEX logs_hostname_idx ON smartia_logs (hostname);
CREATE INDEX logs_appname_idx ON smartia_logs (appname);
CREATE INDEX logs_isindexed_pending_idx ON smartia_logs (id) WHERE isindexed = false;
