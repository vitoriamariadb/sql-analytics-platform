-- Segmentacao de Clientes
-- Classifica clientes por valor e frequencia de compras

SELECT
    CASE
        WHEN total_gasto >= 10000 THEN 'Premium'
        WHEN total_gasto >= 5000 THEN 'Gold'
        WHEN total_gasto >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS segmento,
    COUNT(id_cliente) AS total_clientes,
    SUM(total_gasto) AS receita_segmento,
    AVG(total_gasto) AS gasto_medio,
    AVG(total_compras) AS frequencia_media,
    AVG(ticket_medio) AS ticket_medio_segmento,
    AVG(DATEDIFF(CURDATE(), ultima_compra)) AS dias_media_sem_compra
FROM (
    SELECT
        id_cliente,
        SUM(valor_total) AS total_gasto,
        COUNT(id_venda) AS total_compras,
        AVG(valor_total) AS ticket_medio,
        MAX(data_venda) AS ultima_compra
    FROM vendas
    WHERE data_venda >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
        AND status = 'concluida'
    GROUP BY id_cliente
) AS resumo_cliente
GROUP BY
    CASE
        WHEN total_gasto >= 10000 THEN 'Premium'
        WHEN total_gasto >= 5000 THEN 'Gold'
        WHEN total_gasto >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END
ORDER BY receita_segmento DESC;

