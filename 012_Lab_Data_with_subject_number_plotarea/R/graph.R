# graph.R -- Example 012: N= in plot area
source(file.path(dirname(dirname(getwd())),"R","graph.R"))
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
p<-graph(analfile=df,xvar="visit",yvar="lbresult",
  xlabel="Study Visit",ylabel="Mean ALT (U/L) (95% CI)",effect="trt",
  output="012_Lab_Data_with_subject_number_plotarea",
  central="mean",cidist="t",cilevel=95,vertbar=TRUE,join=TRUE,
  legend=TRUE,corner="UL",annot=TRUE,nlabel="(N=)",xorder=1:8,
  plttitle="Mean ALT — N= Annotation in Plot Area",wantpdf=TRUE,wantpng=TRUE)
