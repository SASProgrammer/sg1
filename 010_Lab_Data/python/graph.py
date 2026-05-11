"""
graph.py  --  Example 010: Basic laboratory data time-series plot
Run build_data.py first.
"""

import sys
import pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parents[2] / "python"))

import pandas as pd
from graph import graph

df = pd.read_csv("test_data.csv")

fig = graph(
    analfile = df,
    xvar     = "visit",
    yvar     = "lbresult",
    xlabel   = "Study Visit",
    ylabel   = "Mean ALT (U/L) (95% CI)",
    effect   = "trt",
    output   = "010_Lab_Data",
    central  = "mean",
    cidist   = "t",
    cilevel  = 95,
    vertbar  = True,
    join     = True,
    legend   = True,
    corner   = "UL",
    annot    = True,
    xorder   = list(range(1, 9)),
    plttitle = "Mean ALT by Treatment Over Study Visits",
    wantpdf  = True,
    wantpng  = True,
)
