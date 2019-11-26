"""
Mocks de conexao e execucao de queries SQL.

Simula conexoes de banco de dados para testes.
"""

from typing import List, Tuple, Any, Optional
from unittest.mock import MagicMock


class MockCursor:
    """Mock de cursor de banco de dados."""

    def __init__(self, results: Optional[List[Tuple]] = None):
        """
        Inicializa cursor mockado.

        Args:
            results: Resultados simulados de query
        """
        self.results = results or []
        self.rowcount = len(self.results)
        self.description = None
        self._index = 0

    def execute(self, query: str, params: Optional[Tuple] = None) -> int:
        """
        Simula execucao de query.

        Args:
            query: Query SQL a executar
            params: Parametros da query

        Returns:
            int: Numero de linhas afetadas
        """
        return self.rowcount

    def fetchall(self) -> List[Tuple]:
        """
        Retorna todos os resultados.

        Returns:
            List[Tuple]: Lista de tuplas com resultados
        """
        return self.results

    def fetchone(self) -> Optional[Tuple]:
        """
        Retorna uma linha de resultado.

        Returns:
            Optional[Tuple]: Tupla com resultado ou None
        """
        if self._index < len(self.results):
            result = self.results[self._index]
            self._index += 1
            return result
        return None

    def fetchmany(self, size: int = 1) -> List[Tuple]:
        """
        Retorna varias linhas de resultado.

        Args:
            size: Numero de linhas a retornar

        Returns:
            List[Tuple]: Lista de tuplas com resultados
        """
        results = self.results[self._index:self._index + size]
        self._index += size
        return results

    def close(self) -> None:
        """Fecha o cursor."""
        pass


class MockConnection:
    """Mock de conexao de banco de dados."""

    def __init__(self, cursor_results: Optional[List[Tuple]] = None):
        """
        Inicializa conexao mockada.

        Args:
            cursor_results: Resultados para cursor mockado
        """
        self.cursor_results = cursor_results
        self.is_connected = True
        self.committed = False
        self.rolled_back = False

    def cursor(self) -> MockCursor:
        """
        Retorna cursor mockado.

        Returns:
            MockCursor: Cursor para executar queries
        """
        return MockCursor(self.cursor_results)

    def commit(self) -> None:
        """Simula commit de transacao."""
        self.committed = True

    def rollback(self) -> None:
        """Simula rollback de transacao."""
        self.rolled_back = True

    def close(self) -> None:
        """Fecha a conexao."""
        self.is_connected = False

    def __enter__(self):
        """Context manager entry."""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit."""
        if exc_type is None:
            self.commit()
        else:
            self.rollback()
        self.close()


def create_mock_connection(results: Optional[List[Tuple]] = None) -> MockConnection:
    """
    Factory para criar conexao mockada.

    Args:
        results: Resultados simulados de queries

    Returns:
        MockConnection: Conexao mockada configurada
    """
    return MockConnection(cursor_results=results)
