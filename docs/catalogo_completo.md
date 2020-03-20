# Catálogo Completo de Queries

Referência de todas as queries disponíveis no SQL Analytics Platform.

## Dashboard Principal

### KPIs Operacionais

**Arquivo:** `queries/dashboards/kpis_principais.sql`

**Descrição:** Calcula indicadores principais para dashboard executivo.

**Métricas:**
- Total de transações
- Valor médio de transação
- Taxa de conversão
- Volume por período

**Uso:**
```sql
\i queries/dashboards/kpis_principais.sql
```

### Análise Temporal

**Arquivo:** `queries/analytics/analise_temporal.sql`

**Descrição:** Análise de tendências temporais com comparativos.

**Métricas:**
- Crescimento mensal
- Sazonalidade
- Comparativo ano anterior
- Projeções simples

## Análises Avançadas

### Segmentação

**Arquivo:** `queries/analytics/segmentacao.sql`

**Descrição:** Segmenta dados por múltiplos critérios.

**Dimensões:**
- Geográfica
- Temporal
- Categórica
- Valor

### Cohort Analysis

**Arquivo:** `queries/analytics/cohort_analysis.sql`

**Descrição:** Análise de coortes por período de entrada.

## ETL

### Extração

**Arquivo:** `queries/etl/extract_dados_operacionais.sql`

**Descrição:** Extrai dados operacionais para análise.

### Transformação

**Arquivo:** `queries/procedures/transform_dados.sql`

**Descrição:** Aplica transformações e limpezas.

### Carga

**Arquivo:** `queries/etl/load_tabelas_fato.sql`

**Descrição:** Carrega dados transformados nas tabelas de destino.

## Validação

### Integridade

**Arquivo:** `queries/validacao/validar_integridade.sql`

**Descrição:** Valida integridade referencial.

### Duplicatas

**Arquivo:** `queries/validacao/validar_duplicatas.sql`

**Descrição:** Detecta e reporta duplicatas.

## Views Materializadas

### mv_kpis_diarios

**Descrição:** KPIs consolidados por dia.

**Atualização:** Diária (execução manual)

**Uso:**
```sql
REFRESH MATERIALIZED VIEW mv_kpis_diarios;
SELECT * FROM mv_kpis_diarios WHERE data >= CURRENT_DATE - 7;
```

---

*Total de queries: 15*
*Última atualização: Março 2020*
