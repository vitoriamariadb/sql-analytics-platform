-- Análise Temporal com Comparativos
-- Otimizado com window functions

WITH dados_mensais AS (
    SELECT
        DATE_TRUNC('month', data_transacao) AS mes,
        COUNT(*) AS total_transacoes,
        SUM(valor) AS receita,
        COUNT(DISTINCT cliente_id) AS clientes_unicos
    FROM transacoes
    WHERE data_transacao >= CURRENT_DATE - INTERVAL '12 months'
        AND status = 'concluida'
    GROUP BY DATE_TRUNC('month', data_transacao)
),
comparativos AS (
    SELECT
        mes,
        total_transacoes,
        receita,
        clientes_unicos,
        LAG(total_transacoes, 1) OVER (ORDER BY mes) AS transacoes_mes_anterior,
        LAG(receita, 1) OVER (ORDER BY mes) AS receita_mes_anterior,
        AVG(total_transacoes) OVER (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS media_movel_3m
    FROM dados_mensais
)
SELECT
    TO_CHAR(mes, 'YYYY-MM') AS mes,
    total_transacoes,
    ROUND(receita::numeric, 2) AS receita,
    clientes_unicos,
    ROUND(media_movel_3m::numeric, 0) AS media_movel_3_meses,
    CASE
        WHEN transacoes_mes_anterior IS NOT NULL THEN
            ROUND(((total_transacoes::numeric - transacoes_mes_anterior) / transacoes_mes_anterior * 100), 2)
        ELSE NULL
    END AS crescimento_percentual
FROM comparativos
ORDER BY mes DESC;

