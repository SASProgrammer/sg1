# build_data.R -- Example 048: QTcB
set.seed(48); N_SUBJ<-60; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); VISITS<-1:8
trt_traj<-list(Placebo=c(400,401,402,402,403,403,402,401),`Drug A 10mg`=c(400,405,410,415,418,420,418,415),`Drug A 25mg`=c(400,408,418,428,435,440,438,432))
records<-list(); subj_n<-1L
for(trt in TRTS){ means<-trt_traj[[trt]]
  for(i in seq_len(N_SUBJ)){ subj_re<-rnorm(1,0,15)
    for(vi in seq_along(VISITS)){ v<-VISITS[vi]; if(v>4&&runif(1)<.08) next
      records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,visit=v,qtcb=round(means[vi]+subj_re+rnorm(1,0,12),1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}}}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
