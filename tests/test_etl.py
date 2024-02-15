"""
Testes para scripts de ETL.

Testa estrutura e logica dos scripts de carga inicial.
"""

from pathlib import Path
import re
import pytest


class TestETLStructure:
    """Testes de estrutura de scripts ETL."""

    def test_etl_carga_inicial_exists(self, etl_dir: Path):
        """
        Testa se script de carga inicial existe.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        carga_file = etl_dir / "01_carga_inicial.sql"
        assert carga_file.exists(), \
            "Script 01_carga_inicial.sql nao existe"

    def test_etl_has_create_table(self, etl_dir: Path):
        """
        Testa se scripts ETL criam tabelas.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        sql_files = list(etl_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_create = 'CREATE TABLE' in content_upper

            assert has_create, \
                f"Script ETL {sql_file.name} deve criar tabelas"

    def test_etl_has_if_not_exists(self, etl_dir: Path):
        """
        Testa se scripts ETL usam IF NOT EXISTS.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        sql_files = list(etl_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_if_not_exists = 'IF NOT EXISTS' in content_upper

            assert has_if_not_exists, \
                f"Script ETL {sql_file.name} deve usar IF NOT EXISTS"

    def test_etl_defines_primary_keys(self, etl_dir: Path):
        """
        Testa se tabelas definem chaves primarias.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        sql_files = list(etl_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_pk = 'PRIMARY KEY' in content_upper

            assert has_pk, \
                f"Tabelas em {sql_file.name} devem definir PRIMARY KEY"

    def test_etl_has_indexes(self, etl_dir: Path):
        """
        Testa se scripts ETL criam indices.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        sql_files = list(etl_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_index = ('INDEX' in content_upper or
                         'KEY' in content_upper)

            assert has_index, \
                f"Script ETL {sql_file.name} deve criar indices"


class TestETLData:
    """Testes de dados de ETL."""

    def test_etl_has_insert_data(self, etl_dir: Path):
        """
        Testa se scripts ETL inserem dados.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        sql_files = list(etl_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_insert = 'INSERT INTO' in content_upper

            assert has_insert, \
                f"Script ETL {sql_file.name} deve inserir dados"

    def test_etl_uses_transactions(self, etl_dir: Path):
        """
        Testa se scripts ETL usam transacoes.

        Args:
            etl_dir: Fixture com Path do diretorio etl/
        """
        sql_files = list(etl_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_transaction = ('START TRANSACTION' in content_upper or
                               'BEGIN' in content_upper)
            has_commit = 'COMMIT' in content_upper

            if has_transaction or has_commit:
                assert has_transaction and has_commit, \
                    f"Script ETL {sql_file.name} deve ter transacao completa"

