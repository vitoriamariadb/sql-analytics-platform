-- KPI de Vendas
-- Calcula métricas principais de vendas por período

SELECT
    DATE_TRUNC('month', data_venda) AS mes,
    COUNT(DISTINCT id_venda) AS total_vendas,
    SUM(valor_total) AS receita_total,
    AVG(valor_total) AS ticket_medio,
    COUNT(DISTINCT id_cliente) AS clientes_unicos
FROM vendas
WHERE data_venda >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', data_venda)
ORDER BY mes DESC;

