# build_data.R -- Example 030: Subject disposition
set.seed(30); TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); N<-100
CATS<-c("Completed","Withdrew Consent","Adverse Event","Lost to Follow-up")
base_pcts<-list(Placebo=c(65,12,15,8),`Drug A 10mg`=c(72,10,12,6),`Drug A 25mg`=c(70,8,17,5)); records<-list()
for(trt in TRTS){ pcts<-base_pcts[[trt]]+rnorm(4,0,1); pcts<-pmax(pcts,0); pcts<-round(100*pcts/sum(pcts),1); pcts[4]<-round(100-sum(pcts[-4]),1)
  for(i in seq_along(CATS)) records[[length(records)+1]]<-data.frame(trt=trt,disposition_cat=CATS[i],n=round(N*pcts[i]/100),pct=pcts[i],stringsAsFactors=FALSE)}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); print(df)
