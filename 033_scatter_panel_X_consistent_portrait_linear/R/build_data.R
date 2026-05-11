# build_data.R -- Example 033
set.seed(33); N_SUBJ<-60; TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); PANELS<-c("Visit 1","Visit 2","Visit 3")
trt_int<-c(Placebo=0,`Drug A 10mg`=6,`Drug A 25mg`=12); panel_shift<-c(`Visit 1`=0,`Visit 2`=5,`Visit 3`=10)
records<-list(); subj_n<-1L
for(panel in PANELS) for(trt in TRTS) for(i in seq_len(N_SUBJ)){ x<-runif(1,10,80); y<-.65*x+trt_int[trt]+panel_shift[panel]+rnorm(1,0,9)
  records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),panel=panel,trt=trt,x_val=round(x,1),y_val=round(y,1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
