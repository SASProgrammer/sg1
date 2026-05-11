# build_data.R -- Example 052: QT vs RR
set.seed(52); N_SUBJ<-100; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); drug_rr<-c(Placebo=0,`Drug A 10mg`=-30,`Drug A 25mg`=-60); drug_qt<-c(Placebo=0,`Drug A 10mg`=8,`Drug A 25mg`=18); records<-list(); subj_n<-1L
for(trt in TRTS) for(i in seq_len(N_SUBJ)){ rr<-rnorm(1,900+drug_rr[trt],80); qt<-.35*rr+drug_qt[trt]+rnorm(1,0,15)
  records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,rr_interval=round(rr,1),qt_interval=round(qt,1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
