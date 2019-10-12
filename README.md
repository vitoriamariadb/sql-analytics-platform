# SQL Analytics Platform

Plataforma de queries SQL para análise de dados operacionais e dashboards.

Desenvolvido em 2019 para análise de dados durante experiência em órgão público.

## Estrutura

```
SQL-Analytics-Platform/
├── queries/
│   ├── kpis/           # Indicadores chave de performance
│   ├── dashboard/      # Queries para dashboards
│   ├── analise/        # Análises e segmentações
│   └── views/          # Views materializadas
├── etl/                # Scripts de ETL e validações
├── procedures/         # Stored procedures
└── docs/               # Documentação completa
```

## Tecnologias

- PostgreSQL 11+
- SQL ANSI padrão
- PL/pgSQL para procedures

## Funcionalidades

### KPIs Operacionais
- Métricas de vendas, produção e qualidade
- Agregações por período
- Indicadores consolidados

### Dashboards
- Dashboard operacional (visão diária)
- Dashboard gerencial (visão mensal)
- Métricas com variações temporais

### Análise de Dados
- Análise temporal (MoM, YoY)
- Segmentação de clientes
- Comparativos e benchmarks

### ETL
- Carga inicial de dados históricos
- Validações de qualidade
- Transformações e limpeza

### Views Materializadas
- Métricas agregadas para performance
- Histórico consolidado
- Atualização via procedures

## Uso

### Executar Query
```bash
psql -U usuario -d database -f queries/kpis/kpi_vendas.sql
```

### Atualizar Métricas
```sql
CALL atualiza_metricas();
```

### Validar Dados
```sql
CALL valida_dados('nome_tabela');
```

## Documentação

Consulte `docs/catalogo_queries.md` para descrição detalhada de cada query, parâmetros e exemplos de uso.

Consulte `docs/fluxo_etl.md` para entender o fluxo de dados e dependências entre queries.

## Convenções

- SQL ANSI padrão
- Nomenclatura em snake_case
- Comentários descritivos em cada arquivo
- Queries organizadas por módulo funcional
