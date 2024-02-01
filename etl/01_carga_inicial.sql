-- ETL: Carga Inicial de Dados
-- Script para setup de tabelas base e carga historica

START TRANSACTION;

-- Tabela de vendas
CREATE TABLE IF NOT EXISTS vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pendente',
    canal VARCHAR(100),
    INDEX idx_vendas_data (data_venda),
    INDEX idx_vendas_cliente (id_cliente),
    INDEX idx_vendas_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de producao
CREATE TABLE IF NOT EXISTS producao (
    id_producao INT AUTO_INCREMENT PRIMARY KEY,
    data_producao DATE NOT NULL,
    quantidade_produzida INT NOT NULL,
    tempo_producao_minutos DECIMAL(10,2),
    id_produto INT NOT NULL,
    lote VARCHAR(50),
    INDEX idx_producao_data (data_producao),
    INDEX idx_producao_produto (id_produto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de controle de qualidade
CREATE TABLE IF NOT EXISTS controle_qualidade (
    id_verificacao INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(100) NOT NULL,
    data_verificacao DATE NOT NULL,
    aprovado TINYINT(1) DEFAULT 0,
    nota_qualidade DECIMAL(5,2),
    observacoes TEXT,
    INDEX idx_qualidade_data (data_verificacao),
    INDEX idx_qualidade_categoria (categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de operacoes
CREATE TABLE IF NOT EXISTS operacoes (
    id_operacao INT AUTO_INCREMENT PRIMARY KEY,
    data_operacao DATE NOT NULL,
    tipo_operacao VARCHAR(100),
    valor DECIMAL(12,2),
    tempo_processamento INT,
    usuario VARCHAR(100),
    status VARCHAR(50) DEFAULT 'ativo',
    INDEX idx_operacoes_data (data_operacao),
    INDEX idx_operacoes_tipo (tipo_operacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de metricas diarias
CREATE TABLE IF NOT EXISTS metricas (
    id_metrica INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    vendas DECIMAL(12,2) DEFAULT 0,
    producao DECIMAL(12,2) DEFAULT 0,
    qualidade DECIMAL(5,2) DEFAULT 0,
    INDEX idx_metricas_data (data)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de log de atualizacoes
CREATE TABLE IF NOT EXISTS log_atualizacoes (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    tipo_atualizacao VARCHAR(100),
    data_execucao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    detalhes TEXT,
    INDEX idx_log_data (data_execucao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de log de validacoes
CREATE TABLE IF NOT EXISTS log_validacoes (
    id_validacao INT AUTO_INCREMENT PRIMARY KEY,
    tabela VARCHAR(100),
    total_registros INT,
    registros_invalidos INT,
    data_validacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    percentual_invalidos DECIMAL(5,2),
    INDEX idx_validacoes_data (data_validacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Carga de dados historicos de vendas
INSERT INTO vendas (id_cliente, data_venda, valor_total, status, canal)
SELECT
    id_cliente,
    data_venda,
    valor_total,
    status,
    canal
FROM fonte_vendas_historico
WHERE data_venda >= '2019-01-01';

-- Carga de dados historicos de producao
INSERT INTO producao (data_producao, quantidade_produzida, tempo_producao_minutos, id_produto, lote)
SELECT
    data_producao,
    quantidade_produzida,
    tempo_producao_minutos,
    id_produto,
    lote
FROM fonte_producao_historico
WHERE data_producao >= '2019-01-01';

COMMIT;

