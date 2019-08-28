-- Análise Temporal
-- Comparativos mês a mês, ano a ano usando window functions

WITH metricas_mensais AS (
    SELECT
        DATE_TRUNC('month', data) AS mes,
        SUM(valor) AS valor_total,
        COUNT(*) AS total_registros,
        AVG(valor) AS valor_medio
    FROM registros
    WHERE data >= CURRENT_DATE - INTERVAL '24 months'
    GROUP BY DATE_TRUNC('month', data)
)
SELECT
    mes,
    valor_total,
    total_registros,
    valor_medio,
    LAG(valor_total) OVER (ORDER BY mes) AS valor_mes_anterior,
    valor_total - LAG(valor_total) OVER (ORDER BY mes) AS variacao_absoluta,
    ROUND(100.0 * (valor_total - LAG(valor_total) OVER (ORDER BY mes)) /
          NULLIF(LAG(valor_total) OVER (ORDER BY mes), 0), 2) AS variacao_percentual,
    LAG(valor_total, 12) OVER (ORDER BY mes) AS valor_ano_anterior,
    ROUND(100.0 * (valor_total - LAG(valor_total, 12) OVER (ORDER BY mes)) /
          NULLIF(LAG(valor_total, 12) OVER (ORDER BY mes), 0), 2) AS crescimento_anual
FROM metricas_mensais
ORDER BY mes DESC;
