# graph.R  --  Example 005: Mean +/- 95% CI time-series plot
# Calls the shared graph() utility from sg1/R/graph.R.
# Run build_data.R first to generate test_data.csv.

source(file.path(dirname(dirname(getwd())), "R", "graph.R"))

df <- read.csv("test_data.csv", stringsAsFactors = FALSE)

p <- graph(
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
  vertbar   = TRUE,
  join      = TRUE,
  legend    = TRUE,
  corner    = "UL",
  annot     = TRUE,
  xorder    = c(0, 4, 8, 12, 16, 24),
  plttitle  = "Mean Score Over Time by Treatment",
  wantpdf   = TRUE,
  wantpng   = TRUE
)
