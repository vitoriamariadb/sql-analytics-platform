-- Procedure: Validar Dados
-- Valida integridade de dados em uma tabela especificada

DELIMITER //

CREATE PROCEDURE proc_valida_dados(
    IN p_tabela VARCHAR(100),
    IN p_data_inicio DATE
)
BEGIN
    DECLARE v_total_registros INT DEFAULT 0;
    DECLARE v_registros_invalidos INT DEFAULT 0;
    DECLARE v_percentual DECIMAL(5,2) DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO log_validacoes (tabela, total_registros, registros_invalidos, data_validacao, percentual_invalidos)
        VALUES (p_tabela, 0, 0, NOW(), 0);
    END;

    START TRANSACTION;

    -- Contar total de registros
    SET @sql_total = CONCAT('SELECT COUNT(*) INTO @v_total FROM ', p_tabela);
    PREPARE stmt FROM @sql_total;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET v_total_registros = @v_total;

    -- Contar registros com problemas
    SET @sql_invalidos = CONCAT(
        'SELECT COUNT(*) INTO @v_inv FROM ', p_tabela,
        ' WHERE id_venda IS NULL OR valor_total <= 0'
    );
    PREPARE stmt FROM @sql_invalidos;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET v_registros_invalidos = @v_inv;

    -- Calcular percentual
    IF v_total_registros > 0 THEN
        SET v_percentual = ROUND(100.0 * v_registros_invalidos / v_total_registros, 2);
    END IF;

    -- Registrar resultado
    INSERT INTO log_validacoes (
        tabela,
        total_registros,
        registros_invalidos,
        data_validacao,
        percentual_invalidos
    ) VALUES (
        p_tabela,
        v_total_registros,
        v_registros_invalidos,
        NOW(),
        v_percentual
    );

    COMMIT;
END //

DELIMITER ;

