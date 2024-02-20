"""
Testes para queries de KPIs operacionais.

Testa estrutura e logica das queries de indicadores.
"""

from pathlib import Path
import re
import pytest


class TestKPIQueries:
    """Testes de queries de KPIs."""

    def test_kpis_query_exists(self, queries_dir: Path):
        """
        Testa se arquivo de KPIs existe.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        kpis_file = queries_dir / "kpis" / "kpis_operacionais.sql"
        assert kpis_file.exists(), "Arquivo kpis_operacionais.sql nao existe"

    def test_kpis_have_aggregations(self, queries_dir: Path):
        """
        Testa se KPIs usam funcoes de agregacao.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        kpis_file = queries_dir / "kpis" / "kpis_operacionais.sql"
        content = kpis_file.read_text(encoding='utf-8')
        content_upper = content.upper()

        aggregation_functions = ['SUM(', 'COUNT(', 'AVG(', 'MAX(', 'MIN(']

        found_aggregations = [func for func in aggregation_functions
                              if func in content_upper]

        assert len(found_aggregations) > 0, \
            "KPIs devem usar funcoes de agregacao"

    def test_kpis_use_group_by(self, queries_dir: Path):
        """
        Testa se KPIs usam GROUP BY quando necessario.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        kpis_file = queries_dir / "kpis" / "kpis_operacionais.sql"
        content = kpis_file.read_text(encoding='utf-8')
        content_upper = content.upper()

        has_aggregation = any(func in content_upper
                              for func in ['SUM(', 'COUNT(', 'AVG('])

        has_group_by = 'GROUP BY' in content_upper

        if has_aggregation and not has_group_by:
            assert False, "Query com agregacao deve ter GROUP BY"

    def test_dashboard_query_exists(self, queries_dir: Path):
        """
        Testa se arquivo de dashboard existe.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        dashboard_file = queries_dir / "dashboard" / "metricas_principais.sql"
        assert dashboard_file.exists(), \
            "Arquivo metricas_principais.sql nao existe"

    def test_temporal_analysis_exists(self, queries_dir: Path):
        """
        Testa se queries de analise temporal existem.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        temporal_dir = queries_dir / "temporal"
        assert temporal_dir.exists(), "Diretorio temporal/ nao existe"

        sql_files = list(temporal_dir.glob("*.sql"))
        assert len(sql_files) > 0, \
            "Nenhuma query de analise temporal encontrada"

    def test_temporal_uses_date_functions(self, queries_dir: Path):
        """
        Testa se queries temporais usam funcoes de data.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        temporal_dir = queries_dir / "temporal"
        sql_files = list(temporal_dir.glob("*.sql"))

        date_functions = ['DATE(', 'YEAR(', 'MONTH(', 'DAY(',
                          'DATEDIFF(', 'DATE_FORMAT(']

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            found_functions = [func for func in date_functions
                               if func in content_upper]

            assert len(found_functions) > 0, \
                f"Query temporal {sql_file.name} deve usar funcoes de data"


class TestSegmentation:
    """Testes de queries de segmentacao."""

    def test_segmentation_queries_exist(self, queries_dir: Path):
        """
        Testa se queries de segmentacao existem.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        segmentation_dir = queries_dir / "segmentacao"
        assert segmentation_dir.exists(), \
            "Diretorio segmentacao/ nao existe"

        sql_files = list(segmentation_dir.glob("*.sql"))
        assert len(sql_files) > 0, \
            "Nenhuma query de segmentacao encontrada"

    def test_segmentation_uses_case(self, queries_dir: Path):
        """
        Testa se queries de segmentacao usam CASE WHEN.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        segmentation_dir = queries_dir / "segmentacao"
        sql_files = list(segmentation_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_case = 'CASE' in content_upper and 'WHEN' in content_upper

            assert has_case, \
                f"Query de segmentacao {sql_file.name} deve usar CASE WHEN"

