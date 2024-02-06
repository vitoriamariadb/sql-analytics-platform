-- Procedure: Atualizar Metricas
-- Recalcula metricas agregadas para um periodo especificado

DELIMITER //

CREATE PROCEDURE proc_atualiza_metricas(
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    DECLARE v_registros_atualizados INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO log_atualizacoes (tipo_atualizacao, data_execucao, status, detalhes)
        VALUES ('refresh_metricas', NOW(), 'erro', 'Falha ao atualizar metricas');
    END;

    START TRANSACTION;

    -- Remover metricas antigas do periodo
    DELETE FROM metricas
    WHERE data BETWEEN p_data_inicio AND p_data_fim;

    -- Recalcular metricas de vendas
    INSERT INTO metricas (data, vendas, producao, qualidade)
    SELECT
        v.data_venda,
        SUM(v.valor_total),
        COALESCE((
            SELECT SUM(p.quantidade_produzida)
            FROM producao p
            WHERE p.data_producao = v.data_venda
        ), 0),
        COALESCE((
            SELECT AVG(q.nota_qualidade)
            FROM controle_qualidade q
            WHERE q.data_verificacao = v.data_venda
        ), 0)
    FROM vendas v
    WHERE v.data_venda BETWEEN p_data_inicio AND p_data_fim
    GROUP BY v.data_venda;

    SET v_registros_atualizados = ROW_COUNT();

    -- Registrar atualizacao
    INSERT INTO log_atualizacoes (tipo_atualizacao, data_execucao, status, detalhes)
    VALUES (
        'refresh_metricas',
        NOW(),
        'sucesso',
        CONCAT('Atualizados ', v_registros_atualizados, ' registros')
    );

    COMMIT;
END //

DELIMITER ;

