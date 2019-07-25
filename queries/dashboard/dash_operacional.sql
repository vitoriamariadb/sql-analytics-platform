-- Dashboard Operacional
-- Visão consolidada de operações diárias

WITH metricas_dia AS (
    SELECT
        CURRENT_DATE AS data,
        COUNT(*) AS total_operacoes,
        SUM(valor) AS valor_total,
        AVG(tempo_processamento) AS tempo_medio
    FROM operacoes
    WHERE data_operacao = CURRENT_DATE
)
SELECT * FROM metricas_dia;
