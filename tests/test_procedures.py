"""
Testes para stored procedures.

Testa estrutura e logica das procedures de transformacao.
"""

from pathlib import Path
import re
import pytest


class TestProcedureStructure:
    """Testes de estrutura de procedures."""

    def test_procedures_use_create_procedure(self, procedures_dir: Path):
        """
        Testa se procedures usam CREATE PROCEDURE.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        sql_files = list(procedures_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            assert 'CREATE PROCEDURE' in content_upper, \
                f"Procedure {sql_file.name} nao usa CREATE PROCEDURE"

    def test_procedures_have_parameters(self, procedures_dir: Path):
        """
        Testa se procedures declaram parametros.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        sql_files = list(procedures_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')

            has_params = re.search(
                r'CREATE PROCEDURE\s+\w+\s*\([^)]+\)',
                content,
                re.IGNORECASE
            )

            assert has_params, \
                f"Procedure {sql_file.name} deve declarar parametros"

    def test_procedures_use_begin_end(self, procedures_dir: Path):
        """
        Testa se procedures usam blocos BEGIN...END.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        sql_files = list(procedures_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_begin = 'BEGIN' in content_upper
            has_end = 'END' in content_upper

            assert has_begin and has_end, \
                f"Procedure {sql_file.name} deve usar BEGIN...END"

    def test_procedures_have_delimiter(self, procedures_dir: Path):
        """
        Testa se procedures resetam DELIMITER.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        sql_files = list(procedures_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            delimiter_count = content_upper.count('DELIMITER')

            assert delimiter_count >= 2, \
                f"Procedure {sql_file.name} deve resetar DELIMITER"


class TestProcedureLogic:
    """Testes de logica de procedures."""

    def test_transformacao_procedure_exists(self, procedures_dir: Path):
        """
        Testa se procedure de transformacao existe.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        transformacao_file = procedures_dir / "sp_transformar_dados.sql"
        assert transformacao_file.exists(), \
            "Procedure sp_transformar_dados.sql nao existe"

    def test_transformacao_has_insert_update(self, procedures_dir: Path):
        """
        Testa se procedure de transformacao faz INSERT/UPDATE.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        transformacao_file = procedures_dir / "sp_transformar_dados.sql"
        content = transformacao_file.read_text(encoding='utf-8')
        content_upper = content.upper()

        has_insert = 'INSERT' in content_upper
        has_update = 'UPDATE' in content_upper

        assert has_insert or has_update, \
            "Procedure de transformacao deve ter INSERT ou UPDATE"

    def test_procedures_have_error_handling(self, procedures_dir: Path):
        """
        Testa se procedures tem tratamento de erros.

        Args:
            procedures_dir: Fixture com Path do diretorio procedures/
        """
        sql_files = list(procedures_dir.glob("*.sql"))

        for sql_file in sql_files:
            content = sql_file.read_text(encoding='utf-8')
            content_upper = content.upper()

            has_handler = 'DECLARE' in content_upper and 'HANDLER' in content_upper

            if not has_handler:
                assert False, \
                    f"Procedure {sql_file.name} deve ter tratamento de erros"
