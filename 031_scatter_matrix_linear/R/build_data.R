# build_data.R -- Example 031: Scatter matrix
set.seed(31); N_SUBJ<-80; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg")
trt_int<-c(Placebo=0,`Drug A 10mg`=5,`Drug A 25mg`=10); records<-list(); subj_n<-1L
for(trt in TRTS) for(i in seq_len(N_SUBJ)){ x<-runif(1,10,80); c<-trt_int[trt]
  records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),trt=trt,x_val=round(x,1),
    y1=round(.7*x+c+rnorm(1,0,8),1),y2=round(.5*x+c*1.2+rnorm(1,0,10),1),y3=round(.9*x+c*.8+rnorm(1,0,6),1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
