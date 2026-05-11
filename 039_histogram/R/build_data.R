# build_data.R -- Example 039: Histogram
set.seed(39); N_SUBJ<-100; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg")
trt_params<-list(Placebo=c(45,15),`Drug A 10mg`=c(55,14),`Drug A 25mg`=c(62,12))
records<-list(); subj_n<-1L
for(trt in TRTS){ p<-trt_params[[trt]]
  for(i in seq_len(N_SUBJ)){ v<-max(0,min(100,rnorm(1,p[1],p[2])))
    records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,value=round(v,1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
