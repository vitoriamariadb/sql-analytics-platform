"""
Configuracao central de fixtures para pytest.

Fixtures reutilizaveis para testes de queries e procedures SQL.
"""

from pathlib import Path
from typing import Dict, Any
import pytest


@pytest.fixture
def db_config() -> Dict[str, Any]:
    """
    Fixture que retorna configuracao de banco de dados para testes.

    Returns:
        Dict[str, Any]: Configuracao com host, user, password, database
    """
    return {
        'host': 'localhost',
        'user': 'test_user',
        'password': 'test_password',
        'database': 'test_analytics',
        'port': 3306
    }


@pytest.fixture
def sample_kpi_data() -> list:
    """
    Fixture que retorna dados de exemplo para KPIs.

    Returns:
        list: Lista de dicionarios com dados de KPIs
    """
    return [
        {
            'id': 1,
            'nome': 'Total Vendas',
            'valor': 150000.00,
            'data': '2019-11-01',
            'categoria': 'vendas'
        },
        {
            'id': 2,
            'nome': 'Ticket Medio',
            'valor': 350.00,
            'data': '2019-11-01',
            'categoria': 'vendas'
        },
        {
            'id': 3,
            'nome': 'Total Clientes',
            'valor': 428,
            'data': '2019-11-01',
            'categoria': 'clientes'
        }
    ]


@pytest.fixture
def sample_query_result() -> list:
    """
    Fixture que retorna resultado simulado de query SQL.

    Returns:
        list: Lista de tuplas simulando resultado de query
    """
    return [
        (1, 'Produto A', 100.50, 50, '2019-11-01'),
        (2, 'Produto B', 250.00, 30, '2019-11-01'),
        (3, 'Produto C', 175.30, 45, '2019-11-02')
    ]


@pytest.fixture
def queries_dir() -> Path:
    """
    Fixture que retorna Path do diretorio de queries.

    Returns:
        Path: Caminho absoluto do diretorio queries/
    """
    return Path(__file__).parent.parent / "queries"


@pytest.fixture
def procedures_dir() -> Path:
    """
    Fixture que retorna Path do diretorio de procedures.

    Returns:
        Path: Caminho absoluto do diretorio procedures/
    """
    return Path(__file__).parent.parent / "procedures"


@pytest.fixture
def etl_dir() -> Path:
    """
    Fixture que retorna Path do diretorio de ETL.

    Returns:
        Path: Caminho absoluto do diretorio etl/
    """
    return Path(__file__).parent.parent / "etl"
