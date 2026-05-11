# build_data.R -- Example 004: Cumulative incidence / time-to-response.
set.seed(4); N_SUBJ<-60; STUDY_END<-24.0; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg")
resp_rates<-c(Placebo=.04,`Drug A 10mg`=.08,`Drug A 25mg`=.12); records<-list(); subj_n<-1L
for(trt in TRTS){ rate<-resp_rates[trt]
  for(i in seq_len(N_SUBJ)){ te<-rexp(1,rate); tc<-runif(1,STUDY_END*.5,STUDY_END); to<-min(te,tc,STUDY_END); resp<-as.integer(te<=tc&te<=STUDY_END)
    records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,time=round(to,2),response=resp,stringsAsFactors=FALSE); subj_n<-subj_n+1L}}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
