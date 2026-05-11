# graph.R -- Example 048: Mean QTcB over visits. Run build_data.R first.
source(file.path(dirname(dirname(getwd())),"R","graph.R"))
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
p<-graph(analfile=df,xvar="visit",yvar="qtcb",xlabel="Study Visit",ylabel="Mean QTcB (ms)",
  effect="trt",output="048_scatter_plot_qtcb",central="mean",cidist="t",cilevel=95,
  vertbar=TRUE,join=TRUE,legend=TRUE,corner="UL",annot=TRUE,xorder=1:8,href=450,
  plttitle="Mean QTcB by Treatment Over Study Visits",wantpdf=TRUE,wantpng=TRUE)
