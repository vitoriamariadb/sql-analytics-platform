-- Dashboard Operacional
-- Visao consolidada de operacoes diarias

SELECT
    o.data_operacao,
    COUNT(o.id_operacao) AS total_operacoes,
    SUM(o.valor) AS valor_total,
    AVG(o.tempo_processamento) AS tempo_medio_processamento,
    SUM(CASE WHEN o.status = 'concluido' THEN 1 ELSE 0 END) AS concluidas,
    SUM(CASE WHEN o.status = 'pendente' THEN 1 ELSE 0 END) AS pendentes,
    ROUND(100.0 * SUM(CASE WHEN o.status = 'concluido' THEN 1 ELSE 0 END) / COUNT(o.id_operacao), 2) AS taxa_conclusao
FROM operacoes o
WHERE o.data_operacao = CURDATE()
GROUP BY o.data_operacao;

