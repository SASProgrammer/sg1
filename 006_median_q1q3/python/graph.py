"""
graph.py  --  Example 006: Median + Q1/Q3 time-series plot
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
    ylabel    = "Median Score (Q1–Q3)",
    effect    = "trt",
    output    = "006_median_q1q3",
    central   = "median",
    vertbar   = True,
    join      = True,
    legend    = True,
    corner    = "UL",
    annot     = True,
    xorder    = [0, 4, 8, 12, 16, 24],
    plttitle  = "Median Score Over Time by Treatment",
    wantpdf   = True,
    wantpng   = True,
)
