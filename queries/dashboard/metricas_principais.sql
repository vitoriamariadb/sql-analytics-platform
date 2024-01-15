-- Metricas Principais do Dashboard
-- Painel consolidado de indicadores para tomada de decisao

SELECT
    DATE_FORMAT(m.data, '%Y-%m-%d') AS data_referencia,
    SUM(m.vendas) AS total_vendas,
    SUM(m.producao) AS total_producao,
    AVG(m.qualidade) AS qualidade_media,
    COUNT(DISTINCT m.data) AS dias_com_dados,
    SUM(m.vendas) / COUNT(DISTINCT m.data) AS media_diaria_vendas,
    SUM(m.producao) / COUNT(DISTINCT m.data) AS media_diaria_producao
FROM metricas m
WHERE m.data >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY DATE_FORMAT(m.data, '%Y-%m-%d')
ORDER BY data_referencia DESC;

