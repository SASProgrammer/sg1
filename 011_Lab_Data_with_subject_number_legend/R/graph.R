# graph.R -- Example 011: Lab data with N= at selected visits, legend area.
source(file.path(dirname(dirname(getwd())),"R","graph.R"))
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
p<-graph(analfile=df,xvar="visit",yvar="lbresult",
  xlabel="Study Visit",ylabel="Mean ALT (U/L) (95% CI)",effect="trt",
  output="011_Lab_Data_with_subject_number_legend",
  central="mean",cidist="t",cilevel=95,vertbar=TRUE,join=TRUE,
  legend=TRUE,corner="UR",annot=TRUE,
  annosel=function(v) v %in% c(1,4,8),
  nlabel="N =",xorder=1:8,
  plttitle="Mean ALT — N Shown at Selected Visits",
  wantpdf=TRUE,wantpng=TRUE)
