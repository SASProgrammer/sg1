# build_data.R -- Example 051
set.seed(51); N_SUBJ<-80; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); conc_range<-list(Placebo=c(0,.5),`Drug A 10mg`=c(.5,3),`Drug A 25mg`=c(2.5,8)); records<-list(); subj_n<-1L
for(trt in TRTS){ cr<-conc_range[[trt]]
  for(i in seq_len(N_SUBJ)){ conc<-runif(1,cr[1],cr[2])
    records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,conc=round(conc,3),rr_interval=round(-8*conc+900+rnorm(1,0,40),1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
