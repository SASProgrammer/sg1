"""
graph.py -- Example 011: Lab data with N= annotation at selected visits (legend area).
Run build_data.py first.
"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parents[2] / "python"))
import pandas as pd
from graph import graph

df = pd.read_csv("test_data.csv")

# annosel: only annotate visits 1, 4, 8
fig = graph(
    analfile = df, xvar="visit", yvar="lbresult",
    xlabel="Study Visit", ylabel="Mean ALT (U/L) (95% CI)",
    effect="trt", output="011_Lab_Data_with_subject_number_legend",
    central="mean", cidist="t", cilevel=95,
    vertbar=True, join=True, legend=True, corner="UR", annot=True,
    annosel=lambda v: v in (1, 4, 8),
    nlabel="N =",
    xorder=list(range(1,9)),
    plttitle="Mean ALT — N Shown at Selected Visits (Legend Area)",
    wantpdf=True, wantpng=True,
)
