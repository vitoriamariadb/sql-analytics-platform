-- ETL: Carga Inicial de Dados
-- Script para setup e carga histórica

BEGIN;

-- Criar tabela staging
CREATE TABLE IF NOT EXISTS staging_dados (
    id SERIAL PRIMARY KEY,
    campo1 VARCHAR(255),
    campo2 NUMERIC,
    campo3 DATE,
    data_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Carga de dados históricos
INSERT INTO staging_dados (campo1, campo2, campo3)
SELECT
    descricao,
    valor,
    data_registro
FROM fonte_externa
WHERE data_registro >= '2019-01-01';

-- Validações básicas
DELETE FROM staging_dados WHERE campo1 IS NULL OR campo2 < 0;

COMMIT;
