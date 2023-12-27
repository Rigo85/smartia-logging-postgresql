CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD '6b0dbc75-39f7-4613-8975-9b49c20ab09d';
SELECT pg_create_physical_replication_slot('replication_slot');

create database smartia_logging;

\c smartia_logging

-- Crear una nueva configuración de búsqueda de texto multilingüe
CREATE TEXT SEARCH CONFIGURATION multilingual ( COPY = pg_catalog.simple );

-- Agregar diccionarios de inglés y español
ALTER TEXT SEARCH CONFIGURATION multilingual
    ALTER MAPPING FOR word, asciiword
    WITH english_stem, spanish_stem;

-- Crear una tabla de ejemplo para almacenar logs
CREATE TABLE smartia_logs (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    data TEXT not null,
    source VARCHAR(255) not null,
    hostname VARCHAR(255) not null,
    appname VARCHAR(255) not null,
    tsvector_multilingual tsvector
);

-- Crear un índice GIN en la columna tsvector
CREATE INDEX logs_tsvector_idx ON smartia_logs USING gin(tsvector_multilingual);

-- Función para actualizar automáticamente el tsvector multilingüe
CREATE OR REPLACE FUNCTION logs_tsvector_trigger() RETURNS trigger AS $$
BEGIN
    NEW.tsvector_multilingual := to_tsvector('multilingual', coalesce(NEW.data, ''));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar el tsvector en cada inserción o actualización
CREATE TRIGGER logs_tsvector_update BEFORE INSERT OR UPDATE
ON smartia_logs FOR EACH ROW EXECUTE FUNCTION logs_tsvector_trigger();
