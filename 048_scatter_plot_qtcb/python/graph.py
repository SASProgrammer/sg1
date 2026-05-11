"""graph.py -- Example 048: Mean QTcB over visits with threshold line. Run build_data.py first."""
import sys, pathlib; sys.path.insert(0,str(pathlib.Path(__file__).parents[2]/"python"))
import pandas as pd; from graph import graph
df=pd.read_csv("test_data.csv")
fig=graph(analfile=df,xvar="visit",yvar="qtcb",xlabel="Study Visit",ylabel="Mean QTcB (ms)",
  effect="trt",output="048_scatter_plot_qtcb",central="mean",cidist="t",cilevel=95,
  vertbar=True,join=True,legend=True,corner="UL",annot=True,
  xorder=list(range(1,9)),href=450,
  plttitle="Mean QTcB by Treatment Over Study Visits",wantpdf=True,wantpng=True)
