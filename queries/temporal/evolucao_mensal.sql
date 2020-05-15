-- Evolucao Mensal
-- Analise de tendencias mensais com comparativos e variacoes

SELECT
    DATE_FORMAT(data_venda, '%Y-%m') AS mes,
    YEAR(data_venda) AS ano,
    MONTH(data_venda) AS mes_numero,
    COUNT(DISTINCT id_venda) AS total_vendas,
    SUM(valor_total) AS receita_total,
    AVG(valor_total) AS ticket_medio,
    COUNT(DISTINCT id_cliente) AS clientes_unicos,
    SUM(valor_total) / COUNT(DISTINCT id_cliente) AS receita_por_cliente
FROM vendas
WHERE data_venda >= DATE_SUB(CURDATE(), INTERVAL 24 MONTH)
    AND status = 'concluida'
GROUP BY
    DATE_FORMAT(data_venda, '%Y-%m'),
    YEAR(data_venda),
    MONTH(data_venda)
ORDER BY mes DESC;
