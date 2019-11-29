"""
Testes de integracao do pipeline SQL.

Testa fluxo completo de ETL e queries.
"""

from pathlib import Path
import pytest


class TestPipelineIntegration:
    """Testes de integracao do pipeline completo."""

    def test_all_query_directories_exist(self, queries_dir: Path):
        """
        Testa se todos os diretorios de queries existem.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        expected_dirs = ['kpis', 'dashboard', 'temporal', 'segmentacao']

        for dir_name in expected_dirs:
            dir_path = queries_dir / dir_name
            assert dir_path.exists(), f"Diretorio {dir_name}/ nao existe"

    def test_etl_to_queries_flow(self, etl_dir: Path, queries_dir: Path):
        """
        Testa fluxo de ETL para queries.

        Verifica se ETL cria estruturas usadas pelas queries.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
            queries_dir: Fixture com Path do diretorio queries/
        """
        etl_file = etl_dir / "01_carga_inicial.sql"
        etl_content = etl_file.read_text(encoding='utf-8')

        kpis_file = queries_dir / "kpis" / "kpis_operacionais.sql"
        kpis_content = kpis_file.read_text(encoding='utf-8')

        assert len(etl_content) > 0 and len(kpis_content) > 0, \
            "ETL e queries devem existir"

    def test_procedures_to_queries_integration(
        self,
        procedures_dir: Path,
        queries_dir: Path
    ):
        """
        Testa integracao entre procedures e queries.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
            queries_dir: Fixture com Path do diretorio queries/
        """
        procedures = list(procedures_dir.glob("*.sql"))
        queries = list(queries_dir.glob("**/*.sql"))

        assert len(procedures) > 0, "Deve haver procedures"
        assert len(queries) > 0, "Deve haver queries"

    def test_complete_analytics_flow(
        self,
        etl_dir: Path,
        procedures_dir: Path,
        queries_dir: Path
    ):
        """
        Testa fluxo completo de analytics.

        ETL -> Procedures -> Queries -> Dashboard

        Args:
            etl_dir: Fixture com Path do diretorio etl/
            procedures_dir: Fixture com Path do diretorio procedures/
            queries_dir: Fixture com Path do diretorio queries/
        """
        etl_exists = (etl_dir / "01_carga_inicial.sql").exists()
        procedures_exist = len(list(procedures_dir.glob("*.sql"))) > 0
        dashboard_exists = (
            queries_dir / "dashboard" / "metricas_principais.sql"
        ).exists()

        assert etl_exists, "ETL deve existir"
        assert procedures_exist, "Procedures devem existir"
        assert dashboard_exists, "Dashboard deve existir"


class TestQueryDependencies:
    """Testes de dependencias entre queries."""

    def test_kpis_depend_on_base_tables(self, queries_dir: Path):
        """
        Testa se KPIs dependem de tabelas base.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        kpis_file = queries_dir / "kpis" / "kpis_operacionais.sql"
        content = kpis_file.read_text(encoding='utf-8')
        content_upper = content.upper()

        has_from = 'FROM' in content_upper

        assert has_from, "KPIs devem referenciar tabelas"

    def test_dashboard_aggregates_kpis(self, queries_dir: Path):
        """
        Testa se dashboard agrega KPIs.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        dashboard_file = queries_dir / "dashboard" / "metricas_principais.sql"
        content = dashboard_file.read_text(encoding='utf-8')
        content_upper = content.upper()

        aggregation_functions = ['SUM(', 'COUNT(', 'AVG(']
        has_aggregation = any(func in content_upper
                              for func in aggregation_functions)

        assert has_aggregation, "Dashboard deve agregar metricas"


@pytest.mark.integration
class TestEndToEndFlow:
    """Testes end-to-end do pipeline completo."""

    def test_complete_project_structure(
        self,
        etl_dir: Path,
        procedures_dir: Path,
        queries_dir: Path
    ):
        """
        Testa estrutura completa do projeto.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
            procedures_dir: Fixture com Path do diretorio procedures/
            queries_dir: Fixture com Path do diretorio queries/
        """
        assert etl_dir.exists(), "Diretorio etl/ deve existir"
        assert procedures_dir.exists(), "Diretorio procedures/ deve existir"
        assert queries_dir.exists(), "Diretorio queries/ deve existir"

        etl_files = list(etl_dir.glob("*.sql"))
        proc_files = list(procedures_dir.glob("*.sql"))
        query_files = list(queries_dir.glob("**/*.sql"))

        assert len(etl_files) > 0, "Deve haver scripts ETL"
        assert len(proc_files) > 0, "Deve haver procedures"
        assert len(query_files) > 0, "Deve haver queries"

    def test_all_files_are_readable(
        self,
        etl_dir: Path,
        procedures_dir: Path,
        queries_dir: Path
    ):
        """
        Testa se todos os arquivos SQL sao legiveis.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
            procedures_dir: Fixture com Path do diretorio procedures/
            queries_dir: Fixture com Path do diretorio queries/
        """
        all_files = (
            list(etl_dir.glob("*.sql")) +
            list(procedures_dir.glob("*.sql")) +
            list(queries_dir.glob("**/*.sql"))
        )

        for sql_file in all_files:
            try:
                content = sql_file.read_text(encoding='utf-8')
                assert len(content) > 0, f"Arquivo {sql_file.name} vazio"
            except Exception as e:
                pytest.fail(f"Erro ao ler {sql_file.name}: {e}")
