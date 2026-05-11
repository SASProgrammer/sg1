# build_data.R -- Example 047: Stacked bar chart
set.seed(47); TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg")
base_dist<-list(Placebo=c(5,15,35,45),`Drug A 10mg`=c(15,30,30,25),`Drug A 25mg`=c(25,40,25,10))
CATS<-c("Complete Response","Partial Response","Stable Disease","Progressive Disease"); records<-list()
for(trt in TRTS){ pcts<-base_dist[[trt]]+rnorm(4,0,2); pcts<-pmax(pcts,0); pcts<-round(100*pcts/sum(pcts),1); pcts[4]<-round(100-sum(pcts[-4]),1)
  for(i in seq_along(CATS)) records[[length(records)+1]]<-data.frame(trt=trt,response_cat=CATS[i],pct=pcts[i],stringsAsFactors=FALSE)}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); print(df)
