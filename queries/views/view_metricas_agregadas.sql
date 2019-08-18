-- View Materializada: Métricas Agregadas
-- Pré-calcula métricas para performance em dashboards

CREATE MATERIALIZED VIEW IF NOT EXISTS view_metricas_agregadas AS
SELECT
    DATE_TRUNC('day', data) AS dia,
    departamento,
    COUNT(*) AS total_registros,
    SUM(valor) AS valor_total,
    AVG(valor) AS valor_medio,
    MIN(valor) AS valor_minimo,
    MAX(valor) AS valor_maximo,
    STDDEV(valor) AS desvio_padrao
FROM registros
WHERE data >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY DATE_TRUNC('day', data), departamento;

CREATE UNIQUE INDEX ON view_metricas_agregadas (dia, departamento);
