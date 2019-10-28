# Fluxo ETL - SQL Analytics Platform

Documentação visual do pipeline ETL e dependências entre queries.

## Visão Geral

```
Fonte de Dados
      |
      v
[carga_inicial.sql] --- Cria staging_dados
      |
      v
[validacoes.sql] ------ Valida qualidade dos dados
      |
      v
[transformacoes.sql] -- Normaliza e enriquece
      |
      v
[proc_atualiza_metricas] - Atualiza views materializadas
      |
      v
Queries de Análise
```

## Fluxo Detalhado

### 1. Carga Inicial (carga_inicial.sql)

**Entrada:** Fonte externa de dados

**Processos:**
- Cria tabela `staging_dados`
- Carrega dados históricos desde 2019-01-01
- Remove registros com valores nulos ou negativos

**Saída:** Tabela `staging_dados` populada

**Frequência:** Execução única ou esporádica

---

### 2. Validações (validacoes.sql)

**Entrada:** Tabela `staging_dados`

**Processos:**
- Identifica duplicados
- Valida ranges de valores
- Verifica consistência de datas
- Detecta campos obrigatórios nulos

**Saída:**
- Relatório de validações
- Tabela `staging_dados` limpa

**Frequência:** Após cada carga

---

### 3. Transformações (transformacoes.sql)

**Entrada:** Tabela `staging_dados` validada

**Processos:**
- Normaliza campos de texto (TRIM, UPPER)
- Padroniza valores numéricos (ROUND)
- Trunca datas para consistência
- Cria campos derivados (mes_referencia, ano_referencia)
- Enriquece com lookup de categorias

**Saída:** Tabela `staging_dados` transformada

**Frequência:** Após validações

---

### 4. Atualização de Views (proc_atualiza_metricas)

**Entrada:** Tabela `staging_dados` final

**Processos:**
- Refresh de `view_metricas_agregadas`
- Refresh de `view_historico`
- Registro em `log_atualizacoes`

**Saída:** Views materializadas atualizadas

**Frequência:** Diária ou sob demanda

---

## Dependências entre Queries

### KPIs
```
staging_dados -> kpi_vendas.sql
staging_dados -> kpi_producao.sql
staging_dados -> kpi_qualidade.sql
```

### Dashboards
```
view_metricas_agregadas -> dash_operacional.sql
view_historico -> dash_gerencial.sql
staging_dados -> metricas_diarias.sql
```

### Análises
```
view_historico -> analise_temporal.sql
staging_dados -> segmentacao.sql
view_metricas_agregadas -> comparativos.sql
```

---

## Ordem de Execução Recomendada

### Setup Inicial
```sql
-- 1. Carga inicial
\i etl/carga_inicial.sql

-- 2. Validações
\i etl/validacoes.sql

-- 3. Transformações
\i etl/transformacoes.sql

-- 4. Criar views materializadas
\i queries/views/view_metricas_agregadas.sql
\i queries/views/view_historico.sql

-- 5. Criar procedures
\i procedures/proc_atualiza_metricas.sql
\i procedures/proc_valida_dados.sql

-- 6. Atualizar métricas
CALL atualiza_metricas();
```

### Atualização Incremental Diária
```sql
-- 1. Validar novos dados
CALL valida_dados('staging_dados');

-- 2. Executar transformações
\i etl/transformacoes.sql

-- 3. Atualizar views
CALL atualiza_metricas();
```

---

## Monitoramento

### Logs de Validação
```sql
SELECT * FROM log_validacoes
ORDER BY data_validacao DESC
LIMIT 10;
```

### Logs de Atualização
```sql
SELECT * FROM log_atualizacoes
WHERE status = 'sucesso'
ORDER BY data_execucao DESC
LIMIT 10;
```

---

## Troubleshooting

### Erro: Views materializadas não atualizam
**Causa:** Locks na tabela base

**Solução:**
```sql
-- Verificar locks
SELECT * FROM pg_locks WHERE relation = 'staging_dados'::regclass;

-- Refresh concorrente
REFRESH MATERIALIZED VIEW CONCURRENTLY view_metricas_agregadas;
```

### Erro: Muitos registros inválidos
**Causa:** Qualidade da fonte de dados

**Solução:**
```sql
-- Executar validações detalhadas
\i etl/validacoes.sql

-- Analisar relatório
SELECT tipo_validacao, registros_afetados
FROM temp.duplicados, temp.valores_invalidos;
```

---

## Performance

### Índices Críticos
- `staging_dados(campo_chave)` - Deduplicação
- `staging_dados(data_registro)` - Filtros temporais
- `view_metricas_agregadas(dia, departamento)` - Consultas agregadas
- `view_historico(data_operacao)` - Análises temporais

### Tempos Esperados
- Carga inicial (100k registros): ~30 segundos
- Validações: ~5 segundos
- Transformações: ~10 segundos
- Refresh views: ~15 segundos

---

## Evolução Futura

- [ ] Automação com cron jobs
- [ ] Particionamento de tabelas por data
- [ ] Compressão de dados históricos
- [ ] Integração com ferramentas de BI
- [ ] Alertas automáticos para anomalias
