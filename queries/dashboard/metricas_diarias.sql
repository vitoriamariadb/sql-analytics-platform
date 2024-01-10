-- Métricas Diárias
-- Acompanhamento diário de indicadores chave

SELECT
    data,
    SUM(vendas) AS vendas_dia,
    SUM(producao) AS producao_dia,
    AVG(qualidade) AS qualidade_media,
    SUM(vendas) - LAG(SUM(vendas)) OVER (ORDER BY data) AS variacao_vendas
FROM metricas
WHERE data >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY data
ORDER BY data DESC;

