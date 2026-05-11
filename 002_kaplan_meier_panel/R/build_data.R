# build_data.R -- Example 002: Paneled KM
set.seed(2); N_SUBJ<-50; STUDY_END<-24.0; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); STRATA<-c("Low","High")
hazard<-list(Low=list(Placebo=.05,`Drug A 10mg`=.03,`Drug A 25mg`=.02),High=list(Placebo=.12,`Drug A 10mg`=.08,`Drug A 25mg`=.05))
records<-list(); subj_n<-1L
for(strat in STRATA) for(trt in TRTS){ rate<-hazard[[strat]][[trt]]
  for(i in seq_len(N_SUBJ)){ te<-rexp(1,rate); tc<-runif(1,STUDY_END*.6,STUDY_END); to<-min(te,tc,STUDY_END); ev<-as.integer(te<=tc&te<=STUDY_END)
    records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),stratum=strat,trt=trt,time=round(to,2),event=ev,stringsAsFactors=FALSE); subj_n<-subj_n+1L}}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
