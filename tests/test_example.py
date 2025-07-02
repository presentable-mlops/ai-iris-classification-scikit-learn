import pytest
import sys
import os

# Add the examples directory to the path so we can import the example module
sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
from examples.example import add  # noqa: E402


def test_add():
    """Test the add function."""
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0
    assert add(-1, -1) == -2
