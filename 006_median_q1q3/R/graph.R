# graph.R  --  Example 006: Median + Q1/Q3 time-series plot
# Run build_data.R first.

source(file.path(dirname(dirname(getwd())), "R", "graph.R"))

df <- read.csv("test_data.csv", stringsAsFactors = FALSE)

p <- graph(
  analfile = df,
  xvar     = "week",
  yvar     = "score",
  xlabel   = "Study Week",
  ylabel   = "Median Score (Q1–Q3)",
  effect   = "trt",
  output   = "006_median_q1q3",
  central  = "median",
  vertbar  = TRUE,
  join     = TRUE,
  legend   = TRUE,
  corner   = "UL",
  annot    = TRUE,
  xorder   = c(0, 4, 8, 12, 16, 24),
  plttitle = "Median Score Over Time by Treatment",
  wantpdf  = TRUE,
  wantpng  = TRUE
)
