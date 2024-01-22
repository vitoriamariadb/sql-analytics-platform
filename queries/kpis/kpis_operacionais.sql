-- KPIs Operacionais
-- Indicadores chave consolidados para acompanhamento operacional

SELECT
    DATE_FORMAT(v.data_venda, '%Y-%m') AS periodo,
    COUNT(DISTINCT v.id_venda) AS total_vendas,
    SUM(v.valor_total) AS receita_total,
    AVG(v.valor_total) AS ticket_medio,
    COUNT(DISTINCT v.id_cliente) AS clientes_ativos,
    SUM(v.valor_total) / COUNT(DISTINCT v.id_cliente) AS receita_por_cliente
FROM vendas v
WHERE v.data_venda >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
    AND v.status = 'concluida'
GROUP BY DATE_FORMAT(v.data_venda, '%Y-%m')
ORDER BY periodo DESC;

