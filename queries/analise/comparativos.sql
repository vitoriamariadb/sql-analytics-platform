-- Análise Comparativa
-- Benchmarks e comparações entre grupos

WITH metricas_por_grupo AS (
    SELECT
        categoria,
        DATE_TRUNC('month', data) AS mes,
        SUM(valor) AS total_valor,
        COUNT(*) AS total_registros,
        AVG(valor) AS valor_medio
    FROM dados
    WHERE data >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY categoria, DATE_TRUNC('month', data)
),
media_geral AS (
    SELECT
        mes,
        AVG(total_valor) AS media_total,
        AVG(valor_medio) AS media_ticket
    FROM metricas_por_grupo
    GROUP BY mes
)
SELECT
    m.categoria,
    m.mes,
    m.total_valor,
    m.total_registros,
    m.valor_medio,
    g.media_total,
    g.media_ticket,
    ROUND(100.0 * (m.total_valor - g.media_total) / NULLIF(g.media_total, 0), 2) AS diferenca_percentual,
    CASE
        WHEN m.total_valor > g.media_total THEN 'Acima da Média'
        WHEN m.total_valor < g.media_total THEN 'Abaixo da Média'
        ELSE 'Na Média'
    END AS classificacao
FROM metricas_por_grupo m
JOIN media_geral g ON m.mes = g.mes
ORDER BY m.mes DESC, m.total_valor DESC;
