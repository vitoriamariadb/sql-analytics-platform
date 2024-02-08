-- Procedure: Transformar Dados
-- Executa transformacoes incrementais em dados brutos

DELIMITER //

CREATE PROCEDURE sp_transformar_dados(
    IN p_data_referencia DATE,
    IN p_modo VARCHAR(50)
)
BEGIN
    DECLARE v_registros_inseridos INT DEFAULT 0;
    DECLARE v_registros_atualizados INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO log_atualizacoes (tipo_atualizacao, data_execucao, status, detalhes)
        VALUES ('transformacao', NOW(), 'erro', CONCAT('Falha na transformacao para ', p_data_referencia));
    END;

    START TRANSACTION;

    -- Inserir novos registros transformados de vendas
    INSERT INTO vendas_transformadas (
        id_venda, id_cliente, data_venda, valor_total,
        mes_referencia, ano_referencia, trimestre,
        canal_normalizado, faixa_valor
    )
    SELECT
        v.id_venda,
        v.id_cliente,
        v.data_venda,
        ROUND(v.valor_total, 2),
        DATE_FORMAT(v.data_venda, '%Y-%m'),
        YEAR(v.data_venda),
        QUARTER(v.data_venda),
        UPPER(TRIM(v.canal)),
        CASE
            WHEN v.valor_total >= 10000 THEN 'Alto'
            WHEN v.valor_total >= 1000 THEN 'Medio'
            ELSE 'Baixo'
        END
    FROM vendas v
    WHERE v.data_venda = p_data_referencia
        AND v.valor_total > 0
        AND v.id_venda NOT IN (SELECT id_venda FROM vendas_transformadas)
    ON DUPLICATE KEY UPDATE
        valor_total = VALUES(valor_total),
        faixa_valor = VALUES(faixa_valor);

    SET v_registros_inseridos = ROW_COUNT();

    -- Atualizar metricas diarias
    UPDATE metricas m
    SET
        vendas = (
            SELECT COALESCE(SUM(valor_total), 0)
            FROM vendas
            WHERE data_venda = m.data
        ),
        producao = (
            SELECT COALESCE(SUM(quantidade_produzida), 0)
            FROM producao
            WHERE data_producao = m.data
        )
    WHERE m.data = p_data_referencia;

    SET v_registros_atualizados = ROW_COUNT();

    -- Registrar execucao
    INSERT INTO log_atualizacoes (tipo_atualizacao, data_execucao, status, detalhes)
    VALUES (
        'transformacao',
        NOW(),
        'sucesso',
        CONCAT('Inseridos: ', v_registros_inseridos, ', Atualizados: ', v_registros_atualizados)
    );

    COMMIT;
END //

DELIMITER ;

