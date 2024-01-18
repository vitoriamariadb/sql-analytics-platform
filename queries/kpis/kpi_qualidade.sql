-- KPI de Qualidade
-- Indicadores de qualidade e conformidade

SELECT
    categoria,
    COUNT(*) AS total_itens,
    SUM(CASE WHEN aprovado = true THEN 1 ELSE 0 END) AS aprovados,
    ROUND(100.0 * SUM(CASE WHEN aprovado = true THEN 1 ELSE 0 END) / COUNT(*), 2) AS taxa_aprovacao,
    AVG(nota_qualidade) AS nota_media
FROM controle_qualidade
WHERE data_verificacao >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY categoria
ORDER BY taxa_aprovacao DESC;

