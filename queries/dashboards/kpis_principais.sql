-- KPIs Principais - Dashboard Executivo
-- Otimizado com índices e CTEs para performance

-- Índices recomendados:
-- CREATE INDEX idx_transacoes_data ON transacoes(data_transacao);
-- CREATE INDEX idx_transacoes_status ON transacoes(status);
-- CREATE INDEX idx_transacoes_valor ON transacoes(valor);

WITH dados_periodo AS (
    SELECT
        DATE_TRUNC('day', data_transacao) AS data,
        COUNT(*) AS total_transacoes,
        SUM(valor) AS receita_total,
        AVG(valor) AS valor_medio
    FROM transacoes
    WHERE data_transacao >= CURRENT_DATE - INTERVAL '30 days'
        AND status = 'concluida'
    GROUP BY DATE_TRUNC('day', data_transacao)
),
metricas_agregadas AS (
    SELECT
        SUM(total_transacoes) AS transacoes_mes,
        SUM(receita_total) AS receita_mes,
        AVG(valor_medio) AS ticket_medio,
        MAX(total_transacoes) AS pico_transacoes,
        MIN(total_transacoes) AS minimo_transacoes
    FROM dados_periodo
)
SELECT
    transacoes_mes,
    ROUND(receita_mes::numeric, 2) AS receita_mes,
    ROUND(ticket_medio::numeric, 2) AS ticket_medio,
    pico_transacoes,
    minimo_transacoes,
    ROUND((receita_mes / transacoes_mes)::numeric, 2) AS receita_por_transacao
FROM metricas_agregadas;
