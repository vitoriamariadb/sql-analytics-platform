-- Procedure: Validar Dados
-- Valida dados incrementalmente antes de processar

CREATE OR REPLACE PROCEDURE valida_dados(p_tabela TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_registros INTEGER;
    v_registros_invalidos INTEGER;
BEGIN
    -- Contar total de registros
    EXECUTE format('SELECT COUNT(*) FROM %I', p_tabela) INTO v_total_registros;

    -- Validar registros
    EXECUTE format('
        SELECT COUNT(*)
        FROM %I
        WHERE (campo1 IS NULL OR campo1 = '''')
           OR (campo2 < 0)
           OR (campo3 > CURRENT_DATE)
    ', p_tabela) INTO v_registros_invalidos;

    -- Registrar resultado da validação
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
        CURRENT_TIMESTAMP,
        ROUND(100.0 * v_registros_invalidos / NULLIF(v_total_registros, 0), 2)
    );

    -- Alertar se há muitos registros inválidos
    IF v_registros_invalidos > v_total_registros * 0.05 THEN
        RAISE WARNING 'Mais de 5%% de registros inválidos na tabela %', p_tabela;
    END IF;

    RAISE NOTICE 'Validação concluída: % registros, % inválidos',
                 v_total_registros, v_registros_invalidos;
END;
$$;
