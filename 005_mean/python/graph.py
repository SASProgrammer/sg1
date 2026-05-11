"""
graph.py  --  Example 005: Mean +/- 95% CI time-series plot
Calls the shared graph() utility from sg1/python/graph.py.

Run build_data.py first to generate test_data.csv.
"""

import sys
import pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parents[2] / "python"))

import pandas as pd
from graph import graph

df = pd.read_csv("test_data.csv")

fig = graph(
    analfile  = df,
    xvar      = "week",
    yvar      = "score",
    xlabel    = "Study Week",
    ylabel    = "Mean Score (95% CI)",
    effect    = "trt",
    output    = "005_mean",
    central   = "mean",
    cidist    = "t",
    cilevel   = 95,
    vertbar   = True,
    join      = True,
    legend    = True,
    corner    = "UL",
    annot     = True,
    xorder    = [0, 4, 8, 12, 16, 24],
    plttitle  = "Mean Score Over Time by Treatment",
    wantpdf   = True,
    wantpng   = True,
)
