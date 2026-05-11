"""
fetch.py  --  Python translation of bae/fetch.sas (Gilead V2015Q1)

Original SAS macro: %fetch()
Coded by: Linda Collins (29Dec1997), last modified Steve Wilson (23Mar2011)
Python translation: auto-generated from SAS source

Fetches a SAS dataset (or any tabular file) from a named library path,
optionally applies subsetting, sorting, column keep, and executes
hardcoding (.hc.py) / analysis-assumption (.inc.py) side-car scripts.

Usage
-----
    from fetch import fetch, register_library

    register_library("rawdata", "/path/to/sas/datasets")

    df = fetch(
        data    = "aevent",
        library = "rawdata",
        dataopt = "anyae == 1",          # pandas query string
        keep    = ["ptid", "body", "prefterm"],
        sortby  = ["ptid", "body", "prefterm"],
    )

Side-car scripts
----------------
For a dataset named ``aevent`` in library path ``/data/``, fetch() looks for:
    /data/aevent.hc.py   -- dataset-specific hardcoding  (if runhc=True)
    /data/_all_.hc.py    -- universal hardcoding          (if runhc=True)
    /data/aevent.inc.py  -- dataset-specific recoding     (if runinc=True)
    /data/_all_.inc.py   -- universal recoding            (if runinc=True)

Each script receives a local variable ``df`` (the current DataFrame) and
must reassign ``df`` to produce the modified result.

Dependencies
------------
    pip install pandas pyreadstat
"""

from __future__ import annotations

import os
import warnings
from pathlib import Path
from typing import Callable, Sequence, Union

import pandas as pd

# ---------------------------------------------------------------------------
# Library registry  (mirrors SAS LIBNAME assignments)
# ---------------------------------------------------------------------------
_libraries: dict[str, str] = {}


def register_library(name: str, path: str) -> None:
    """Register a named library path (equivalent to SAS LIBNAME statement)."""
    _libraries[name.lower()] = str(path)


def _resolve_library(library: str) -> str:
    """Return the filesystem path for a registered library name."""
    key = library.lower()
    if key in _libraries:
        return _libraries[key]
    # Allow raw filesystem paths to be passed directly
    if os.path.isdir(library):
        return library
    raise ValueError(
        f"Library '{library}' is not registered and is not a valid directory. "
        "Use register_library() first."
    )


# ---------------------------------------------------------------------------
# Side-car script executor
# ---------------------------------------------------------------------------
def _run_sidecar(script_path: str, df: pd.DataFrame) -> pd.DataFrame:
    """Execute a Python side-car script with ``df`` in scope; return modified df."""
    local_ns = {"df": df}
    with open(script_path, encoding="utf-8") as fh:
        exec(compile(fh.read(), script_path, "exec"), {}, local_ns)  # noqa: S102
    return local_ns.get("df", df)


# ---------------------------------------------------------------------------
# Main fetch function
# ---------------------------------------------------------------------------
def fetch(
    data: str,
    library: str = "rawdata",
    out: str | None = None,
    dataopt: str | Callable | None = None,
    outopt: str | None = None,
    sortby: str | Sequence[str] | None = None,
    keep: str | Sequence[str] | None = None,
    runhc: bool = True,
    runinc: bool = True,
    debug: bool = False,
) -> pd.DataFrame:
    """
    Fetch a SAS dataset (or CSV/Parquet fallback) from a named library.

    Parameters
    ----------
    data : str
        Dataset name (without extension).
    library : str
        Registered library name or filesystem path.  Default: "rawdata".
    out : str, optional
        Not used to redirect output in Python (return value is always the df).
        Kept for API parity with the SAS macro.
    dataopt : str or callable, optional
        Subsetting applied immediately after load.
        - str  → passed to ``df.query(dataopt)``
        - callable → called as ``dataopt(df)`` and must return a filtered df.
    outopt : str, optional
        Not applicable in Python (kept for API parity).
    sortby : str or list of str, optional
        Column(s) to sort by.  Accepts ``"col1 col2"`` or ``["col1", "col2"]``.
    keep : str or list of str, optional
        Columns to retain in the output.
        Accepts ``"col1 col2"`` or ``["col1", "col2"]``.
    runhc : bool
        Execute dataset-specific and universal hardcoding scripts.
    runinc : bool
        Execute dataset-specific and universal analysis-assumption scripts.
    debug : bool
        Print diagnostic messages and show 10-row sample prints.

    Returns
    -------
    pd.DataFrame
    """
    # ------------------------------------------------------------------
    # Resolve library path
    # ------------------------------------------------------------------
    try:
        lib_path = Path(_resolve_library(library))
    except ValueError as exc:
        raise RuntimeError(str(exc)) from exc

    if debug:
        print(f"**NOTE: Fetching dataset : {data}")
        print(f"**NOTE: From library     : {library} → {lib_path}")
        print(f"**NOTE: Parm dataopt     : {dataopt}")
        print(f"**NOTE: Parm sortby      : {sortby}")
        print(f"**NOTE: Parm keep        : {keep}")
        print(f"**NOTE: Parm runhc       : {runhc}")
        print(f"**NOTE: Parm runinc      : {runinc}")

    # ------------------------------------------------------------------
    # Find and load the dataset  (.sas7bdat → .csv → .parquet)
    # ------------------------------------------------------------------
    sas_file = lib_path / f"{data.lower()}.sas7bdat"
    csv_file = lib_path / f"{data.lower()}.csv"
    parquet_file = lib_path / f"{data.lower()}.parquet"

    if sas_file.exists():
        try:
            import pyreadstat  # noqa: PLC0415
            df, _ = pyreadstat.read_sas7bdat(str(sas_file))
        except ImportError:
            df = pd.read_sas(str(sas_file), format="sas7bdat", encoding="utf-8")
    elif csv_file.exists():
        df = pd.read_csv(str(csv_file))
    elif parquet_file.exists():
        df = pd.read_parquet(str(parquet_file))
    else:
        raise FileNotFoundError(
            f"Cannot find dataset '{data}' in library '{library}' ({lib_path}). "
            "Expected one of: .sas7bdat, .csv, .parquet"
        )

    if debug:
        print("\n10 Sample Observations After Initial Retrieval:")
        print(df.head(10).to_string())

    # ------------------------------------------------------------------
    # Apply dataopt subsetting
    # ------------------------------------------------------------------
    if dataopt is not None:
        if callable(dataopt):
            df = dataopt(df)
        else:
            df = df.query(dataopt)

    # ------------------------------------------------------------------
    # Hardcoding files  (.hc.py)
    # ------------------------------------------------------------------
    if runhc:
        for script_name in (f"{data.lower()}.hc.py", "_all_.hc.py"):
            script = lib_path / script_name
            if script.exists():
                print(f"**FETCH: Applying hardcoding file: {script}")
                if dataopt is not None:
                    warnings.warn(
                        "DATAOPT is in effect and a hardcoding script is being executed. "
                        "Options applied BEFORE hardcoding.",
                        stacklevel=2,
                    )
                df = _run_sidecar(str(script), df)
                if debug:
                    print(f"\n10 Sample Observations After Applying Hardcoding ({script_name}):")
                    print(df.head(10).to_string())
    else:
        for script_name in (f"{data.lower()}.hc.py", "_all_.hc.py"):
            if (lib_path / script_name).exists():
                print(f"**NOTE: Hardcode processing suppressed: {lib_path / script_name}")

    # ------------------------------------------------------------------
    # Analysis assumption / recoding files  (.inc.py)
    # ------------------------------------------------------------------
    if runinc:
        for script_name in (f"{data.lower()}.inc.py", "_all_.inc.py"):
            script = lib_path / script_name
            if script.exists():
                print(f"**FETCH: Applying analysis assumption file: {script}")
                if dataopt is not None:
                    warnings.warn(
                        "DATAOPT is in effect and an analysis-assumptions script is being executed. "
                        "Options applied BEFORE recoding.",
                        stacklevel=2,
                    )
                df = _run_sidecar(str(script), df)
                if debug:
                    print(f"\n10 Sample Observations After Applying Recoding ({script_name}):")
                    print(df.head(10).to_string())
    else:
        for script_name in (f"{data.lower()}.inc.py", "_all_.inc.py"):
            if (lib_path / script_name).exists():
                print(f"**NOTE: Analysis assumption processing suppressed: {lib_path / script_name}")

    # ------------------------------------------------------------------
    # Sort
    # ------------------------------------------------------------------
    if sortby is not None:
        if isinstance(sortby, str):
            sortby = sortby.split()
        df = df.sort_values(by=list(sortby)).reset_index(drop=True)

    # ------------------------------------------------------------------
    # Keep columns
    # ------------------------------------------------------------------
    if keep is not None:
        if isinstance(keep, str):
            keep = keep.split()
        missing = [c for c in keep if c not in df.columns]
        if missing:
            warnings.warn(f"KEEP columns not found in dataset and will be ignored: {missing}", stacklevel=2)
        keep = [c for c in keep if c in df.columns]
        df = df[keep]

    if debug:
        print("\n10 Sample Observations from Output Dataset After Retrieval Completed:")
        print(df.head(10).to_string())
        print(f"\n**NOTE: Macro termination: fetch")

    return df
