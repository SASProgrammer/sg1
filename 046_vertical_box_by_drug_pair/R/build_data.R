# build_data.R -- Example 046: Box plots
set.seed(46); N_SUBJ<-60; PAIRS<-c("Pair 1","Pair 2","Pair 3"); TRTS<-c("Drug A","Drug B")
pair_means<-list(`Pair 1`=list(`Drug A`=50,`Drug B`=45),`Pair 2`=list(`Drug A`=60,`Drug B`=55),`Pair 3`=list(`Drug A`=55,`Drug B`=48)); records<-list(); subj_n<-1L
for(pair in PAIRS) for(trt in TRTS) for(i in seq_len(N_SUBJ)){ records[[length(records)+1]]<-data.frame(subjid=sprintf("S%04d",subj_n),drug_pair=pair,trt=trt,value=round(rnorm(1,pair_means[[pair]][[trt]],12),1),stringsAsFactors=FALSE); subj_n<-subj_n+1L}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
