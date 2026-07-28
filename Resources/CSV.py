"""CSV helpers for Robot Framework DataManager."""

from __future__ import annotations

import csv
from pathlib import Path
from typing import Any


class CSV:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def get_row_by_column(
        self,
        filepath: str,
        column: str,
        value: str,
    ) -> dict[str, str]:
        """Return the first row where ``column`` equals ``value`` (case-sensitive)."""
        path = Path(filepath)
        if not path.is_file():
            raise FileNotFoundError(f"CSV not found: {path}")
        with path.open(newline="", encoding="utf-8") as handle:
            reader = csv.DictReader(handle)
            if reader.fieldnames is None or column not in reader.fieldnames:
                raise ValueError(f"Column {column!r} not in {reader.fieldnames}")
            for row in reader:
                if row.get(column, "") == value:
                    return {k: (v or "") for k, v in row.items()}
        raise ValueError(f"No row in {path} where {column}={value!r}")

    def read_all_rows(self, filepath: str) -> list[dict[str, str]]:
        path = Path(filepath)
        if not path.is_file():
            raise FileNotFoundError(f"CSV not found: {path}")
        with path.open(newline="", encoding="utf-8") as handle:
            reader = csv.DictReader(handle)
            return [{k: (v or "") for k, v in row.items()} for row in reader]
