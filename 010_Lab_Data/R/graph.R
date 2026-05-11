# graph.R  --  Example 010: Basic laboratory data time-series plot
# Run build_data.R first.

source(file.path(dirname(dirname(getwd())), "R", "graph.R"))

df <- read.csv("test_data.csv", stringsAsFactors = FALSE)

p <- graph(
  analfile = df, xvar="visit", yvar="lbresult",
  xlabel="Study Visit", ylabel="Mean ALT (U/L) (95% CI)",
  effect="trt", output="010_Lab_Data",
  central="mean", cidist="t", cilevel=95,
  vertbar=TRUE, join=TRUE, legend=TRUE, corner="UL", annot=TRUE,
  xorder=1:8,
  plttitle="Mean ALT by Treatment Over Study Visits",
  wantpdf=TRUE, wantpng=TRUE
)
