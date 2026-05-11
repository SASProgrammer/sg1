# build_data.R -- Example 041
set.seed(41); N_SUBJ<-50; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); trt_mean<-c(Placebo=5,`Drug A 10mg`=-20,`Drug A 25mg`=-40); records<-list(); subj_n<-1L
for(trt in TRTS) for(i in seq_len(N_SUBJ)){ records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,pct_change=round(max(-100,min(100,trt_mean[trt]+rnorm(1,0,25))),1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}
df<-do.call(rbind,records)|>(\(d) d[order(d$trt,d$pct_change),])(); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
