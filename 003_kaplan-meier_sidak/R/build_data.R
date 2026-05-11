# build_data.R -- Example 003: KM with Sidak CI. Same data as 001.
set.seed(3); N_SUBJ<-50; STUDY_END<-24.0; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg")
hazard<-c(Placebo=.08,`Drug A 10mg`=.05,`Drug A 25mg`=.03); records<-list(); subj_n<-1L
for(trt in TRTS){ rate<-hazard[trt]
  for(i in seq_len(N_SUBJ)){ te<-rexp(1,rate); tc<-runif(1,STUDY_END*.6,STUDY_END); to<-min(te,tc,STUDY_END); ev<-as.integer(te<=tc&te<=STUDY_END)
    records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,time=round(to,2),event=ev,stringsAsFactors=FALSE); subj_n<-subj_n+1L}}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
