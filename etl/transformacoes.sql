-- ETL: Transformacoes de Dados
-- Cria tabelas de dados transformados e popula com dados normalizados

START TRANSACTION;

-- Tabela de vendas transformadas
CREATE TABLE IF NOT EXISTS vendas_transformadas (
    id_venda INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL,
    mes_referencia VARCHAR(7),
    ano_referencia INT,
    trimestre INT,
    canal_normalizado VARCHAR(100),
    faixa_valor VARCHAR(50),
    INDEX idx_vt_data (data_venda),
    INDEX idx_vt_cliente (id_cliente),
    INDEX idx_vt_mes (mes_referencia),
    INDEX idx_vt_faixa (faixa_valor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de producao transformada
CREATE TABLE IF NOT EXISTS producao_transformada (
    id_producao INT PRIMARY KEY,
    data_producao DATE NOT NULL,
    quantidade_produzida INT NOT NULL,
    tempo_producao_minutos DECIMAL(10,2),
    produtividade DECIMAL(10,4),
    mes_referencia VARCHAR(7),
    ano_referencia INT,
    INDEX idx_pt_data (data_producao),
    INDEX idx_pt_mes (mes_referencia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Transformacao de vendas: normalizar e enriquecer
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
WHERE v.valor_total > 0
    AND v.data_venda IS NOT NULL
ON DUPLICATE KEY UPDATE
    valor_total = VALUES(valor_total),
    canal_normalizado = VALUES(canal_normalizado),
    faixa_valor = VALUES(faixa_valor);

-- Transformacao de producao: calcular produtividade
INSERT INTO producao_transformada (
    id_producao, data_producao, quantidade_produzida,
    tempo_producao_minutos, produtividade,
    mes_referencia, ano_referencia
)
SELECT
    p.id_producao,
    p.data_producao,
    p.quantidade_produzida,
    p.tempo_producao_minutos,
    CASE
        WHEN p.tempo_producao_minutos > 0
        THEN p.quantidade_produzida / p.tempo_producao_minutos
        ELSE 0
    END,
    DATE_FORMAT(p.data_producao, '%Y-%m'),
    YEAR(p.data_producao)
FROM producao p
WHERE p.quantidade_produzida > 0
ON DUPLICATE KEY UPDATE
    quantidade_produzida = VALUES(quantidade_produzida),
    produtividade = VALUES(produtividade);

COMMIT;
