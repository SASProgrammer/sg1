# build_data.R -- Example 013: Paneled lab data
set.seed(13); N_SUBJ<-50; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); VISITS<-1:8
LABS<-c("ALT","Creatinine","Hemoglobin")
trt_traj<-list(
  ALT=list(Placebo=c(28,28,29,29,30,30,30,29),`Drug A 10mg`=c(28,29,31,33,34,34,33,32),`Drug A 25mg`=c(28,31,36,41,43,44,42,40),sd=7),
  Creatinine=list(Placebo=c(.9,.91,.92,.92,.93,.93,.93,.92),`Drug A 10mg`=c(.9,.92,.95,.97,.98,.98,.97,.96),`Drug A 25mg`=c(.9,.95,1,1.05,1.07,1.08,1.07,1.05),sd=.12),
  Hemoglobin=list(Placebo=c(13.5,13.4,13.3,13.3,13.2,13.2,13.2,13.3),`Drug A 10mg`=c(13.5,13.6,13.8,14,14,14.1,14.1,14),`Drug A 25mg`=c(13.5,13.8,14.2,14.5,14.6,14.7,14.7,14.6),sd=1)
)
records<-list(); subj_n<-1L
for(lab in LABS){ cfg<-trt_traj[[lab]]
  for(trt in TRTS){ means<-cfg[[trt]]; sd<-cfg$sd
    for(i in seq_len(N_SUBJ)){ subj_re<-rnorm(1,0,sd*.4)
      for(vi in seq_along(VISITS)){ v<-VISITS[vi]; if(v>4&&runif(1)<.08) next
        records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),labtest=lab,trt=trt,visit=v,lbresult=round(means[vi]+subj_re+rnorm(1,0,sd),3),stringsAsFactors=FALSE)}
      subj_n<-subj_n+1L}}}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE)
message(sprintf("Generated %d rows.",nrow(df)))
