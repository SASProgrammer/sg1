# build_data.R -- Example 042: Waterfall
set.seed(42); N_SUBJ<-50; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); trt_mean<-c(Placebo=10,`Drug A 10mg`=-25,`Drug A 25mg`=-45); records<-list(); subj_n<-1L
for(trt in TRTS) for(i in seq_len(N_SUBJ)){ records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,best_pct_change=round(max(-100,min(100,trt_mean[trt]+rnorm(1,0,30))),1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}
df<-do.call(rbind,records)|>(\(d) d[order(d$best_pct_change),])(); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
