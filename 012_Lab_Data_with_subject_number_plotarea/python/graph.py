"""
graph.py -- Example 012: Lab data with N= annotation inside the plot area.
Run build_data.py first.
"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parents[2] / "python"))
import pandas as pd
from graph import graph

df = pd.read_csv("test_data.csv")
fig = graph(
    analfile=df, xvar="visit", yvar="lbresult",
    xlabel="Study Visit", ylabel="Mean ALT (U/L) (95% CI)",
    effect="trt", output="012_Lab_Data_with_subject_number_plotarea",
    central="mean", cidist="t", cilevel=95,
    vertbar=True, join=True, legend=True, corner="UL",
    annot=True, nlabel="(N=)",
    xorder=list(range(1,9)),
    plttitle="Mean ALT — N= Annotation in Plot Area",
    wantpdf=True, wantpng=True,
)
