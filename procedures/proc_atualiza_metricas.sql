-- Procedure: Atualizar Métricas
-- Atualiza métricas agregadas incrementalmente

CREATE OR REPLACE PROCEDURE atualiza_metricas()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Atualizar view materializada de métricas
    REFRESH MATERIALIZED VIEW CONCURRENTLY view_metricas_agregadas;

    -- Atualizar view materializada de histórico
    REFRESH MATERIALIZED VIEW CONCURRENTLY view_historico;

    -- Registrar atualização
    INSERT INTO log_atualizacoes (
        tipo_atualizacao,
        data_execucao,
        status
    ) VALUES (
        'refresh_metricas',
        CURRENT_TIMESTAMP,
        'sucesso'
    );

    RAISE NOTICE 'Métricas atualizadas com sucesso';
END;
$$;
