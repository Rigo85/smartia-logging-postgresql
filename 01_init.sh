#!/bin/bash
set -e

# Copiar el archivo postgresql.conf personalizado al directorio de datos
cp /custom-config/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp /custom-config/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
