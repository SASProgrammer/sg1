# build_data.R -- Example 045
set.seed(45); TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); VISITS<-c(4,8,12,24)
base_resp<-c(Placebo=.10,`Drug A 10mg`=.30,`Drug A 25mg`=.50); time_inc<-c(Placebo=.02,`Drug A 10mg`=.05,`Drug A 25mg`=.07); records<-list()
for(vis in VISITS) for(trt in TRTS){ p<-min(.9,base_resp[trt]+time_inc[trt]*(vis/4)); n<-rbinom(1,80,p)
  records[[length(records)+1]]<-data.frame(trt=trt,visit=vis,n=n,pct=round(100*n/80,1),stringsAsFactors=FALSE)}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
