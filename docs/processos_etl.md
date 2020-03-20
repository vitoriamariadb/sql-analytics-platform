# Processos ETL - SQL Analytics Platform

Documentação dos processos de Extract, Transform, Load (ETL) implementados.

## Visão Geral

Este projeto implementa processos ETL básicos em SQL para:
- Extração de dados de múltiplas fontes
- Transformação e limpeza de dados
- Carga em tabelas de destino
- Validação de qualidade dos dados

## Arquitetura ETL

### 1. Extract (Extração)

**Queries de Extração:**
- `queries/etl/extract_dados_operacionais.sql`
- `queries/etl/extract_dados_analiticos.sql`

**Fontes de Dados:**
- Tabelas operacionais transacionais
- Views de sistemas legados
- Arquivos CSV externos

### 2. Transform (Transformação)

**Procedures de Transformação:**
- `queries/procedures/transform_dados.sql`
- `queries/procedures/limpar_dados.sql`
- `queries/procedures/normalizar_formatos.sql`

**Regras de Transformação:**
- Padronização de formatos de data
- Normalização de strings
- Tratamento de valores nulos
- Agregações e cálculos

### 3. Load (Carga)

**Scripts de Carga:**
- `queries/etl/load_tabelas_fato.sql`
- `queries/etl/load_tabelas_dimensao.sql`

**Estratégias de Carga:**
- Full load (carga completa)
- Incremental load (carga incremental)
- Upsert (insert ou update)

## Validação de Dados

**Queries de Validação:**
- `queries/validacao/validar_integridade.sql`
- `queries/validacao/validar_duplicatas.sql`
- `queries/validacao/validar_valores_nulos.sql`

**Critérios de Qualidade:**
- Integridade referencial
- Unicidade de chaves
- Completude de dados obrigatórios
- Formato de campos

## Execução

### Ordem de Execução

1. Execute validações pré-carga
2. Execute extrações
3. Execute transformações
4. Execute cargas
5. Execute validações pós-carga

### Exemplo de Uso

```sql
-- 1. Validação pré-carga
\i queries/validacao/validar_integridade.sql

-- 2. Extração
\i queries/etl/extract_dados_operacionais.sql

-- 3. Transformação
CALL transform_dados();

-- 4. Carga
\i queries/etl/load_tabelas_fato.sql

-- 5. Validação pós-carga
\i queries/validacao/validar_duplicatas.sql
```

## Monitoramento

Logs de execução são salvos em:
- `logs/etl_execucao.log`
- `logs/etl_erros.log`

## Troubleshooting

### Problema: Dados duplicados

**Solução:** Execute `queries/validacao/validar_duplicatas.sql` e corrija na fonte.

### Problema: Erro de integridade referencial

**Solução:** Verifique ordem de execução das cargas. Carregue dimensões antes de fatos.

---

*Desenvolvido em 2020 durante experiência em análise de dados*
