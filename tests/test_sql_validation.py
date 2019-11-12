"""
Testes unitarios para validacao de sintaxe SQL.

Testa se queries e procedures possuem sintaxe valida.
"""

from pathlib import Path
import re
import pytest


class TestSQLSyntax:
    """Testes de sintaxe SQL basica."""

    def test_queries_files_exist(self, queries_dir: Path):
        """
        Testa se diretorio de queries existe e contem arquivos.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        assert queries_dir.exists(), "Diretorio queries/ nao existe"
        assert queries_dir.is_dir(), "queries/ nao e um diretorio"

        sql_files = list(queries_dir.glob("**/*.sql"))
        assert len(sql_files) > 0, "Nenhum arquivo .sql encontrado"

    def test_procedures_files_exist(self, procedures_dir: Path):
        """
        Testa se diretorio de procedures existe e contem arquivos.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        assert procedures_dir.exists(), "Diretorio procedures/ nao existe"
        assert procedures_dir.is_dir(), "procedures/ nao e um diretorio"

        sql_files = list(procedures_dir.glob("*.sql"))
        assert len(sql_files) > 0, "Nenhum arquivo .sql encontrado"

    def test_etl_files_exist(self, etl_dir: Path):
        """
        Testa se diretorio de ETL existe e contem arquivos.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        assert etl_dir.exists(), "Diretorio etl/ nao existe"
        assert etl_dir.is_dir(), "etl/ nao e um diretorio"

        sql_files = list(etl_dir.glob("*.sql"))
        assert len(sql_files) > 0, "Nenhum arquivo .sql encontrado"

    def test_queries_have_select(self, queries_dir: Path):
        """
        Testa se queries contem instrucoes SELECT.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        sql_files = list(queries_dir.glob("**/*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            assert 'SELECT' in content_upper, \
                f"Query {sql_file.name} nao contem SELECT"

    def test_procedures_have_delimiter(self, procedures_dir: Path):
        """
        Testa se procedures usam DELIMITER corretamente.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        sql_files = list(procedures_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            assert 'DELIMITER' in content_upper, \
                f"Procedure {sql_file.name} nao define DELIMITER"

    def test_no_hardcoded_database(self, queries_dir: Path):
        """
        Testa se queries nao usam nome de database hardcoded.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        sql_files = list(queries_dir.glob("**/*.sql"))
        forbidden_patterns = [r'USE\s+\w+', r'FROM\s+\w+\.\w+']

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')

            for pattern in forbidden_patterns:
                matches = re.findall(pattern, content, re.IGNORECASE)

                if matches:
                    assert False, \
                        f"Query {sql_file.name} tem database hardcoded: {matches}"

    def test_sql_files_utf8(self, queries_dir: Path):
        """
        Testa se arquivos SQL estao em UTF-8.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        sql_files = list(queries_dir.glob("**/*.sql"))

        for sql_file in sql_files:
            try:
                content = sql_file.read_text(encoding='utf-8')
                assert len(content) > 0, f"Arquivo {sql_file.name} vazio"
            except UnicodeDecodeError:
                pytest.fail(f"Arquivo {sql_file.name} nao esta em UTF-8")


class TestSQLBestPractices:
    """Testes de boas praticas SQL."""

    def test_queries_have_comments(self, queries_dir: Path):
        """
        Testa se queries possuem comentarios descritivos.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        sql_files = list(queries_dir.glob("**/*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')

            has_comment = ('--' in content) or ('/*' in content and '*/' in content)

            assert has_comment, \
                f"Query {sql_file.name} nao possui comentarios"

    def test_no_select_star(self, queries_dir: Path):
        """
        Testa se queries evitam SELECT *.

        Args:
            queries_dir: Fixture com Path do diretorio queries/
        """
        sql_files = list(queries_dir.glob("**/*.sql"))
        select_star_pattern = r'SELECT\s+\*\s+FROM'

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')

            matches = re.findall(select_star_pattern, content, re.IGNORECASE)

            if matches:
                assert False, \
                    f"Query {sql_file.name} usa SELECT * (evite isso)"
