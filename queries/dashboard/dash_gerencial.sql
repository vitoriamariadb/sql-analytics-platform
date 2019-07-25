-- Dashboard Gerencial
-- Métricas para gestão e tomada de decisão

SELECT
    departamento,
    COUNT(*) AS total_processos,
    AVG(prazo_dias) AS prazo_medio,
    SUM(CASE WHEN status = 'concluido' THEN 1 ELSE 0 END) AS concluidos,
    ROUND(100.0 * SUM(CASE WHEN status = 'concluido' THEN 1 ELSE 0 END) / COUNT(*), 2) AS taxa_conclusao
FROM processos
WHERE data_inicio >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY departamento;
