"""
graph.py  --  Python translation of bae/graph.sas (Gilead V2015Q1)

Original SAS macro: %graph()
Coded by: Bryan Selby (May 1998), last modified Steve Wilson (03Nov2010)
Python translation: auto-generated from SAS source

Creates median/IQR or mean/CI (or mean/SD) time-series plots across
treatment groups, with optional sample-size annotations and flexible
axis/legend control.

Usage
-----
    import pandas as pd
    from graph import graph

    graph(
        analfile = df,
        xvar     = "week",
        yvar     = "value",
        xlabel   = "Study Week",
        ylabel   = "Mean Score",
        effect   = "treatment",
        output   = "my_graph",
        central  = "mean",
        cidist   = "t",
        cilevel  = 95,
    )

Dependencies
------------
    pip install pandas matplotlib scipy numpy
"""

from __future__ import annotations

import warnings
from pathlib import Path
from typing import Callable, Sequence

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np
import pandas as pd
from scipy import stats

# ---------------------------------------------------------------------------
# Symbol / marker mapping (mirrors SAS MARKER font symbol names)
# ---------------------------------------------------------------------------
_SYMBOL_MAP: dict[str, str] = {
    "circle":    "o",
    "ecircle":   "o",   # empty (unfilled) circle — approximated
    "square":    "s",
    "esquare":   "s",
    "diamond":   "D",
    "ediamond":  "D",
    "triangle":  "^",
    "etriangle": "^",
    "tri1":      "^",
    "tri2":      ">",
    "tri3":      "v",
    "etri3":     "v",
    "tri4":      "<",
    "star":      "*",
    "x":         "x",
    "+":         "P",
    "*":         "*",
    "heart":     (8, 2, 0),  # matplotlib path symbol; fallback to "o" if needed
}

_FILLED_MARKERS = {"circle", "square", "diamond", "triangle", "tri1", "tri2", "tri3", "tri4", "star"}

_DEFAULT_SYMBOLS = ["circle", "ecircle", "etriangle", "esquare", "ediamond", "etri3", "+", "x"]

_CORNER_MAP = {
    "UL": "upper left",
    "UR": "upper right",
    "LL": "lower left",
    "LR": "lower right",
}

_LINE_STYLES = ["-", "--", "-.", ":", (0, (3, 1, 1, 1)), (0, (5, 1))]

_COLORS = ["black", "tab:blue", "tab:red", "tab:green", "tab:orange", "tab:purple", "tab:brown", "tab:pink"]


def _marker_for(sym: str, filled: bool) -> str | tuple:
    m = _SYMBOL_MAP.get(sym.lower(), "o")
    if isinstance(m, tuple):
        return m
    return m


def _is_filled(sym: str) -> bool:
    base = sym.lstrip("e").lower()
    return base in _FILLED_MARKERS or not sym.lower().startswith("e")


# ---------------------------------------------------------------------------
# Statistics helpers
# ---------------------------------------------------------------------------
def _compute_stats(
    df: pd.DataFrame,
    group_cols: list[str],
    yvar: str,
    central: str,
    cidist: str,
    cilevel: float,
    lbzero: bool,
) -> pd.DataFrame:
    """Return per-group summary statistics: median/q1/q3/n  or  mean/q1/q3/n."""
    alpha = 1.0 - cilevel / 100.0

    def _agg(g: pd.DataFrame) -> pd.Series:
        y = g[yvar].dropna()
        n = len(y)

        if central.upper() == "MEDIAN":
            center = y.median()
            q1 = y.quantile(0.25)
            q3 = y.quantile(0.75)
        else:  # MEAN
            center = y.mean()
            sd = y.std(ddof=1) if n > 1 else 0.0
            sem = sd / np.sqrt(n) if n > 0 else 0.0

            if cidist.upper() == "SD":
                q3 = center + sd
                q1 = max(center - sd, 0.0) if lbzero else center - sd
                if lbzero and center <= 0:
                    q3 = 0.0
                    q1 = 0.0
            elif cidist.upper() == "STDERR":
                q3 = center + sem
                q1 = max(center - sem, 0.0) if lbzero else center - sem
            elif cidist.upper() == "Z":
                z = stats.norm.ppf(1.0 - alpha / 2.0)
                q1 = center - sem * z
                q3 = center + sem * z
            else:  # default: t
                if n > 1:
                    t_crit = stats.t.ppf(1.0 - alpha / 2.0, df=n - 1)
                    q1 = center - sem * t_crit
                    q3 = center + sem * t_crit
                else:
                    q1 = center
                    q3 = center

        if n <= 1:
            q1 = center
            q3 = center

        return pd.Series({"center": center, "q1": q1, "q3": q3, "n": n})

    result = df.groupby(group_cols, sort=False, observed=True).apply(_agg).reset_index()
    return result


# ---------------------------------------------------------------------------
# Main graph function
# ---------------------------------------------------------------------------
def graph(
    analfile: pd.DataFrame,
    xvar: str,
    yvar: str,
    xlabel: str,
    ylabel: str,
    effect: str,
    output: str = "graph",
    titlekey: str | None = None,
    gsfmode: str = "replace",
    scond: str | Callable | None = None,
    efffmt: Callable | None = None,
    byvar: str | Sequence[str] | None = None,
    ttlsize: float = 14,
    footsize: float = 11,
    labelsize: float = 12,
    numsize: float = 10,
    textsize: float = 10,
    symsize: float = 8,
    symbols: Sequence[str] | None = None,
    legend: bool = True,
    corner: str = "UL",
    legx: float | None = None,
    legy: float | None = None,
    solidln: bool = False,
    symsame: bool = False,
    xaxsize: float | None = None,
    join: bool = True,
    xorigin: float | None = None,
    yorigin: float | None = None,
    xfmt: str | Callable | None = None,
    xorder: Sequence | None = None,
    href: float | Sequence[float] | None = None,
    yorder: Sequence | None = None,
    log: bool = False,
    plttitle: str | None = None,
    vref: float | Sequence[float] | None = None,
    vertbar: bool = True,
    central: str = "median",
    cilevel: float = 95,
    cidist: str = "t",
    lbzero: bool = True,
    spread: float = 1.0,
    annot: bool = True,
    annosel: Callable | None = None,
    annosize: float = 8,
    nlabel: str = "(n=)",
    extanno: pd.DataFrame | None = None,
    wantpdf: bool = True,
    wantpng: bool = True,
    figsize: tuple[float, float] = (10, 7),
    dpi: int = 150,
    debug: bool = False,
    **kwargs,
) -> plt.Figure:
    """
    Create a median/IQR or mean/CI time-series plot.

    Parameters
    ----------
    analfile : pd.DataFrame
        Input analysis dataset.
    xvar : str
        Column name for the X (horizontal) axis variable.
    yvar : str
        Column name for the Y (vertical) axis variable.
    xlabel : str
        Label text for the X axis.
    ylabel : str
        Label text for the Y axis.
    effect : str
        Column name for the treatment / grouping variable.
    output : str
        Base filename (without extension) for saved output.
    central : {"median", "mean"}
        Measure of central tendency.
    cidist : {"t", "Z", "SD", "STDERR"}
        Distribution / method used when central="mean".
    cilevel : float
        Confidence level percentage (default 95).
    lbzero : bool
        When cidist="SD" and central="mean", force lower bound to 0.
    spread : float
        Horizontal stagger amount for multiple groups at the same X point.
    vertbar : bool
        Draw vertical error bars (IQR or CI).
    join : bool
        Connect central-tendency points with lines.
    legend : bool
        Show the symbol legend.
    corner : {"UL", "UR", "LL", "LR"}
        Corner for legend placement.
    annot : bool
        Annotate sample sizes (N=) below the plot.
    log : bool
        Use log10 scale on the Y axis.
    wantpdf : bool
        Save output as PDF.
    wantpng : bool
        Save output as PNG.

    Returns
    -------
    matplotlib.figure.Figure
    """
    # ------------------------------------------------------------------
    # 1. Subset
    # ------------------------------------------------------------------
    df = analfile.copy()

    if scond is not None:
        if callable(scond):
            df = scond(df)
        else:
            df = df.query(scond)

    df = df.dropna(subset=[xvar, yvar])

    if df.empty:
        warnings.warn("No data remain after subsetting — nothing to plot.", stacklevel=2)
        return plt.figure()

    # ------------------------------------------------------------------
    # 2. Staggering adjustment
    # ------------------------------------------------------------------
    effect_levels = df[effect].unique()
    # Sort to make order deterministic
    try:
        effect_levels = sorted(effect_levels)
    except TypeError:
        effect_levels = list(effect_levels)

    adj_n = len(effect_levels)

    # Middle group → adjust=0; others stagger left/right
    def _stagger(idx: int) -> float:
        center = (adj_n / 2.0 + 0.5)
        return ((idx + 1) - center) * (0.6 / adj_n) * spread

    stagger_map = {lvl: _stagger(i) for i, lvl in enumerate(effect_levels)}
    df["newx"] = df[xvar] + df[effect].map(stagger_map)

    # ------------------------------------------------------------------
    # 3. Compute statistics
    # ------------------------------------------------------------------
    group_cols = []
    if byvar is not None:
        if isinstance(byvar, str):
            group_cols = [byvar]
        else:
            group_cols = list(byvar)
    group_cols += ["newx", effect, xvar]

    stats_df = _compute_stats(df, group_cols, yvar, central, cidist, cilevel, lbzero)

    if debug:
        print("Statistics dataset:")
        print(stats_df.head(20).to_string())

    # ------------------------------------------------------------------
    # 4. Build the plot
    # ------------------------------------------------------------------
    if symbols is None:
        symbols = _DEFAULT_SYMBOLS

    symbol_list = list(symbols) if not isinstance(symbols, list) else symbols

    corner_key = corner.upper()
    if corner_key not in _CORNER_MAP:
        raise ValueError(f"CORNER must be one of UL, UR, LL, LR — got '{corner}'")
    legend_loc = _CORNER_MAP[corner_key]

    fig, ax = plt.subplots(figsize=figsize)

    if log:
        ax.set_yscale("log")

    for i, lvl in enumerate(effect_levels):
        grp = stats_df[stats_df[effect] == lvl].sort_values("newx")

        sym_name = symbol_list[i % len(symbol_list)] if not symsame else symbol_list[0]
        marker = _marker_for(sym_name, _is_filled(sym_name))
        fill_kw = {} if _is_filled(sym_name) else {"markerfacecolor": "none"}
        linestyle = "-" if solidln else _LINE_STYLES[i % len(_LINE_STYLES)]
        color = _COLORS[i % len(_COLORS)]

        label = efffmt(lvl) if efffmt is not None else str(lvl)

        plot_kw = dict(
            marker=marker,
            markersize=symsize,
            color=color,
            label=label,
            zorder=3,
            **fill_kw,
        )

        if join:
            ax.plot(grp["newx"], grp["center"], linestyle=linestyle, linewidth=2, **plot_kw)
        else:
            ax.plot(grp["newx"], grp["center"], linestyle="none", **plot_kw)

        if vertbar:
            yerr_lo = (grp["center"] - grp["q1"]).clip(lower=0)
            yerr_hi = (grp["q3"] - grp["center"]).clip(lower=0)
            ax.errorbar(
                grp["newx"],
                grp["center"],
                yerr=[yerr_lo.values, yerr_hi.values],
                fmt="none",
                ecolor=color,
                elinewidth=2,
                capsize=0,
                zorder=2,
            )

    # ------------------------------------------------------------------
    # 5. Reference lines
    # ------------------------------------------------------------------
    if href is not None:
        hrefs = [href] if isinstance(href, (int, float)) else list(href)
        for h in hrefs:
            ax.axhline(h, color="gray", linewidth=1, linestyle="--", zorder=1)

    if vref is not None:
        vrefs = [vref] if isinstance(vref, (int, float)) else list(vref)
        for v in vrefs:
            ax.axvline(v, color="gray", linewidth=1, linestyle="--", zorder=1)

    # ------------------------------------------------------------------
    # 6. Axes formatting
    # ------------------------------------------------------------------
    ax.set_xlabel(xlabel, fontsize=labelsize, fontweight="bold")
    ax.set_ylabel(ylabel, fontsize=labelsize, fontweight="bold")
    ax.tick_params(labelsize=numsize)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)

    if xorder is not None:
        xorder = list(xorder)
        ax.set_xlim(min(xorder), max(xorder))
        ax.set_xticks(xorder)

    if yorder is not None:
        yorder = list(yorder)
        ax.set_ylim(min(yorder), max(yorder))
        ax.set_yticks(yorder)

    if xfmt is not None:
        if callable(xfmt):
            ax.xaxis.set_major_formatter(matplotlib.ticker.FuncFormatter(lambda v, _: xfmt(v)))
        elif isinstance(xfmt, str):
            ax.xaxis.set_major_formatter(matplotlib.ticker.FormatStrFormatter(xfmt))

    if plttitle:
        ax.set_title(plttitle, fontsize=ttlsize, fontweight="bold")

    # ------------------------------------------------------------------
    # 7. Legend
    # ------------------------------------------------------------------
    if legend and adj_n > 0:
        handles, labels = ax.get_legend_handles_labels()
        if legx is not None and legy is not None:
            ax.legend(
                handles, labels,
                loc="lower left",
                bbox_to_anchor=(legx / 100.0, legy / 100.0),
                bbox_transform=fig.transFigure,
                fontsize=textsize,
                frameon=False,
            )
        else:
            ax.legend(handles, labels, loc=legend_loc, fontsize=textsize, frameon=False)

    # ------------------------------------------------------------------
    # 8. Sample-size annotation (N=) below X axis
    # ------------------------------------------------------------------
    if annot:
        anno_df = stats_df.copy()
        if annosel is not None:
            anno_df = anno_df[anno_df[xvar].map(annosel)]

        # Group by xvar × effect; use the unique newx per group
        anno_grp = anno_df.groupby([xvar, effect], sort=False, observed=True).first().reset_index()

        y_min = ax.get_ylim()[0]
        y_range = ax.get_ylim()[1] - y_min
        anno_y_step = y_range * 0.04 * (annosize / 8.0)

        for row_idx, (lvl_idx, lvl) in enumerate(enumerate(effect_levels)):
            grp_anno = anno_grp[anno_grp[effect] == lvl].sort_values(xvar)
            label_prefix = efffmt(lvl) if efffmt is not None else str(lvl)
            y_pos = y_min - anno_y_step * (row_idx + 1.5)

            for _, arow in grp_anno.iterrows():
                ax.text(
                    arow["newx"],
                    y_pos,
                    f"{label_prefix} {nlabel}: {int(arow['n'])}",
                    fontsize=annosize,
                    ha="center",
                    va="top",
                    clip_on=False,
                    transform=ax.transData,
                )

        # Expand bottom margin to make room for annotations
        fig.subplots_adjust(bottom=0.15 + 0.04 * adj_n)

    # ------------------------------------------------------------------
    # 9. External annotation overlay
    # ------------------------------------------------------------------
    if extanno is not None and isinstance(extanno, pd.DataFrame):
        for _, row in extanno.iterrows():
            ax.annotate(
                str(row.get("text", "")),
                xy=(row.get("x", 0), row.get("y", 0)),
                fontsize=annosize,
                ha=row.get("ha", "center"),
                va=row.get("va", "center"),
            )

    # ------------------------------------------------------------------
    # 10. Save output
    # ------------------------------------------------------------------
    out_path = Path(output)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    if wantpdf:
        fig.savefig(str(out_path) + ".pdf", bbox_inches="tight", dpi=dpi)
        print(f"NOTE: Saved {out_path}.pdf")

    if wantpng:
        fig.savefig(str(out_path) + ".png", bbox_inches="tight", dpi=dpi)
        print(f"NOTE: Saved {out_path}.png")

    return fig
