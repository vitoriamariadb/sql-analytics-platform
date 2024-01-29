-- View Materializada: Histórico
-- Consolida histórico de operações para consultas rápidas

CREATE MATERIALIZED VIEW IF NOT EXISTS view_historico AS
SELECT
    id,
    data_operacao,
    tipo_operacao,
    usuario,
    valor,
    status,
    DATE_TRUNC('month', data_operacao) AS mes,
    DATE_TRUNC('year', data_operacao) AS ano
FROM operacoes_historico
WHERE data_operacao >= '2019-01-01';

CREATE INDEX ON view_historico (data_operacao);
CREATE INDEX ON view_historico (mes);
CREATE INDEX ON view_historico (tipo_operacao);

