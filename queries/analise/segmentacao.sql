-- Segmentação de Dados
-- Análise de grupos e categorias

WITH segmentos AS (
    SELECT
        id_cliente,
        SUM(valor_compra) AS total_gasto,
        COUNT(*) AS total_compras,
        AVG(valor_compra) AS ticket_medio,
        MAX(data_compra) AS ultima_compra,
        CURRENT_DATE - MAX(data_compra) AS dias_sem_comprar
    FROM vendas
    WHERE data_compra >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY id_cliente
)
SELECT
    CASE
        WHEN total_gasto >= 10000 THEN 'Premium'
        WHEN total_gasto >= 5000 THEN 'Gold'
        WHEN total_gasto >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS segmento,
    COUNT(*) AS total_clientes,
    SUM(total_gasto) AS receita_total,
    AVG(total_gasto) AS gasto_medio,
    AVG(total_compras) AS compras_media,
    AVG(ticket_medio) AS ticket_medio_segmento,
    AVG(dias_sem_comprar) AS dias_media_sem_comprar
FROM segmentos
GROUP BY
    CASE
        WHEN total_gasto >= 10000 THEN 'Premium'
        WHEN total_gasto >= 5000 THEN 'Gold'
        WHEN total_gasto >= 1000 THEN 'Silver'
        ELSE 'Bronze'
    END
ORDER BY receita_total DESC;

