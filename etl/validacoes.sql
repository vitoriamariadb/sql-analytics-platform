-- ETL: Validacoes de Dados
-- Cria tabelas de controle de qualidade e registra resultados de validacao

START TRANSACTION;

-- Tabela de resultados de validacao
CREATE TABLE IF NOT EXISTS resultados_validacao (
    id_resultado INT AUTO_INCREMENT PRIMARY KEY,
    tipo_validacao VARCHAR(100) NOT NULL,
    tabela_origem VARCHAR(100) NOT NULL,
    registros_afetados INT DEFAULT 0,
    data_validacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalhes TEXT,
    INDEX idx_rv_tipo (tipo_validacao),
    INDEX idx_rv_data (data_validacao),
    INDEX idx_rv_tabela (tabela_origem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de registros rejeitados
CREATE TABLE IF NOT EXISTS registros_rejeitados (
    id_rejeicao INT AUTO_INCREMENT PRIMARY KEY,
    tabela_origem VARCHAR(100) NOT NULL,
    id_registro_original INT,
    motivo_rejeicao VARCHAR(255),
    data_rejeicao DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_rr_tabela (tabela_origem),
    INDEX idx_rr_data (data_rejeicao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Validacao de vendas: registros com valor negativo ou nulo
INSERT INTO resultados_validacao (tipo_validacao, tabela_origem, registros_afetados, detalhes)
SELECT
    'Valores Invalidos',
    'vendas',
    COUNT(*),
    CONCAT('Registros com valor_total <= 0 ou nulo: ', COUNT(*))
FROM vendas
WHERE valor_total <= 0 OR valor_total IS NULL;

-- Validacao de vendas: datas futuras
INSERT INTO resultados_validacao (tipo_validacao, tabela_origem, registros_afetados, detalhes)
SELECT
    'Datas Futuras',
    'vendas',
    COUNT(*),
    CONCAT('Registros com data futura: ', COUNT(*))
FROM vendas
WHERE data_venda > CURDATE();

-- Validacao de producao: quantidades invalidas
INSERT INTO resultados_validacao (tipo_validacao, tabela_origem, registros_afetados, detalhes)
SELECT
    'Quantidades Invalidas',
    'producao',
    COUNT(*),
    CONCAT('Registros com quantidade <= 0: ', COUNT(*))
FROM producao
WHERE quantidade_produzida <= 0;

-- Registrar vendas rejeitadas
INSERT INTO registros_rejeitados (tabela_origem, id_registro_original, motivo_rejeicao)
SELECT
    'vendas',
    id_venda,
    CASE
        WHEN valor_total <= 0 OR valor_total IS NULL THEN 'Valor invalido'
        WHEN data_venda > CURDATE() THEN 'Data futura'
        ELSE 'Outro'
    END
FROM vendas
WHERE valor_total <= 0
   OR valor_total IS NULL
   OR data_venda > CURDATE();

COMMIT;
