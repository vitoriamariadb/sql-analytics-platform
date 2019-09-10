-- ETL: Validações de Dados
-- Checks de qualidade de dados, constraints e consistência

BEGIN;

-- Validação 1: Dados duplicados
CREATE TEMP TABLE duplicados AS
SELECT campo_chave, COUNT(*) as ocorrencias
FROM staging_dados
GROUP BY campo_chave
HAVING COUNT(*) > 1;

-- Validação 2: Valores fora do range esperado
CREATE TEMP TABLE valores_invalidos AS
SELECT *
FROM staging_dados
WHERE valor < 0 OR valor > 999999;

-- Validação 3: Datas inconsistentes
CREATE TEMP TABLE datas_invalidas AS
SELECT *
FROM staging_dados
WHERE data_registro > CURRENT_DATE
   OR data_registro < '2010-01-01';

-- Validação 4: Campos obrigatórios nulos
CREATE TEMP TABLE campos_nulos AS
SELECT *
FROM staging_dados
WHERE campo_obrigatorio IS NULL;

-- Relatório de validações
SELECT
    'Duplicados' AS tipo_validacao,
    COUNT(*) AS registros_afetados
FROM duplicados
UNION ALL
SELECT 'Valores Inválidos', COUNT(*) FROM valores_invalidos
UNION ALL
SELECT 'Datas Inválidas', COUNT(*) FROM datas_invalidas
UNION ALL
SELECT 'Campos Nulos', COUNT(*) FROM campos_nulos;

-- Remover registros inválidos
DELETE FROM staging_dados
WHERE campo_chave IN (SELECT campo_chave FROM duplicados)
   OR id IN (SELECT id FROM valores_invalidos)
   OR id IN (SELECT id FROM datas_invalidas)
   OR id IN (SELECT id FROM campos_nulos);

COMMIT;
