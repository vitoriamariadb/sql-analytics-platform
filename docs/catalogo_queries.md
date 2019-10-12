# Catálogo de Queries

Documentação completa de todas as queries disponíveis na plataforma.

## KPIs Operacionais

### kpi_vendas.sql
**Descrição:** Calcula métricas principais de vendas por período mensal.

**Métricas:**
- Total de vendas
- Receita total
- Ticket médio
- Clientes únicos

**Período:** Últimos 12 meses

**Uso:**
```bash
psql -U usuario -d database -f queries/kpis/kpi_vendas.sql
```

---

### kpi_producao.sql
**Descrição:** Métricas de produtividade e volume de produção diária.

**Métricas:**
- Volume total produzido
- Tempo médio de produção
- Total de lotes
- Produtividade (volume/tempo)

**Período:** Últimos 30 dias

---

### kpi_qualidade.sql
**Descrição:** Indicadores de qualidade e conformidade por categoria.

**Métricas:**
- Total de itens verificados
- Taxa de aprovação
- Nota média de qualidade

**Período:** Últimos 7 dias

---

## Dashboards

### dash_operacional.sql
**Descrição:** Visão consolidada de operações do dia atual.

**Métricas:**
- Total de operações
- Valor total processado
- Tempo médio de processamento

---

### dash_gerencial.sql
**Descrição:** Métricas para gestão e tomada de decisão por departamento.

**Métricas:**
- Total de processos
- Prazo médio
- Taxa de conclusão

**Período:** Últimos 30 dias

---

### metricas_diarias.sql
**Descrição:** Acompanhamento diário de indicadores chave com variação.

**Métricas:**
- Vendas do dia
- Produção do dia
- Qualidade média
- Variação de vendas (dia anterior)

**Período:** Últimos 30 dias

---

## Views Materializadas

### view_metricas_agregadas.sql
**Descrição:** Pré-calcula métricas agregadas por dia e departamento.

**Atualização:** Via procedure `atualiza_metricas()`

**Índices:** Único em (dia, departamento)

---

### view_historico.sql
**Descrição:** Consolida histórico de operações para consultas rápidas.

**Índices:**
- data_operacao
- mes
- tipo_operacao

---

## Análise de Dados

### analise_temporal.sql
**Descrição:** Comparativos mês a mês e ano a ano com window functions.

**Métricas:**
- Variação absoluta e percentual mensal
- Crescimento anual (YoY)

**Período:** Últimos 24 meses

---

### segmentacao.sql
**Descrição:** Segmentação de clientes por valor de compra.

**Segmentos:**
- Premium (>= R$ 10.000)
- Gold (>= R$ 5.000)
- Silver (>= R$ 1.000)
- Bronze (< R$ 1.000)

**Período:** Últimos 12 meses

---

### comparativos.sql
**Descrição:** Benchmarks e comparações entre categorias.

**Análises:**
- Comparação com média geral
- Classificação (acima/abaixo/na média)
- Diferença percentual

**Período:** Últimos 6 meses

---

## ETL

### carga_inicial.sql
**Descrição:** Setup e carga histórica de dados.

**Operações:**
- Cria tabela staging
- Carrega dados de fonte externa
- Valida dados básicos

---

### validacoes.sql
**Descrição:** Checks de qualidade e consistência de dados.

**Validações:**
- Dados duplicados
- Valores fora do range
- Datas inconsistentes
- Campos obrigatórios nulos

**Saída:** Relatório de validações e remoção de inválidos

---

## Procedures

### proc_atualiza_metricas.sql
**Descrição:** Atualiza views materializadas incrementalmente.

**Uso:**
```sql
CALL atualiza_metricas();
```

---

### proc_valida_dados.sql
**Descrição:** Valida dados de tabela específica.

**Parâmetros:**
- `p_tabela` - Nome da tabela a validar

**Uso:**
```sql
CALL valida_dados('staging_dados');
```

---

## Convenções

- Todas as queries usam SQL ANSI padrão
- Comentários descritivos no início de cada arquivo
- Nomenclatura em snake_case
- Agregações sempre com GROUP BY explícito
- Datas sempre com DATE_TRUNC para consistência
