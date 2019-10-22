-- ETL: Transformações de Dados
-- Scripts de transformação e normalização

BEGIN;

-- Transformação 1: Normalizar campos de texto
UPDATE staging_dados
SET campo_texto = TRIM(UPPER(campo_texto))
WHERE campo_texto IS NOT NULL;

-- Transformação 2: Converter valores numéricos
UPDATE staging_dados
SET campo_valor = ROUND(campo_valor::NUMERIC, 2)
WHERE campo_valor IS NOT NULL;

-- Transformação 3: Padronizar datas
UPDATE staging_dados
SET campo_data = DATE_TRUNC('day', campo_data)
WHERE campo_data IS NOT NULL;

-- Transformação 4: Criar campos derivados
ALTER TABLE staging_dados ADD COLUMN IF NOT EXISTS mes_referencia VARCHAR(7);
ALTER TABLE staging_dados ADD COLUMN IF NOT EXISTS ano_referencia INTEGER;

UPDATE staging_dados
SET
    mes_referencia = TO_CHAR(campo_data, 'YYYY-MM'),
    ano_referencia = EXTRACT(YEAR FROM campo_data)
WHERE campo_data IS NOT NULL;

-- Transformação 5: Enriquecimento com lookup
UPDATE staging_dados s
SET categoria = l.categoria_nome
FROM lookup_categorias l
WHERE s.id_categoria = l.id;

COMMIT;
