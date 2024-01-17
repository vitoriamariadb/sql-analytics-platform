-- KPI de Produção
-- Métricas de produtividade e volume

SELECT
    DATE_TRUNC('day', data_producao) AS dia,
    SUM(quantidade_produzida) AS volume_total,
    AVG(tempo_producao_minutos) AS tempo_medio,
    COUNT(*) AS total_lotes,
    SUM(quantidade_produzida) / NULLIF(SUM(tempo_producao_minutos), 0) AS produtividade
FROM producao
WHERE data_producao >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE_TRUNC('day', data_producao)
ORDER BY dia DESC;

