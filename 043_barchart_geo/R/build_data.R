# build_data.R -- Example 043: Grouped bar chart
set.seed(43); TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); N<-c(Placebo=80,`Drug A 10mg`=80,`Drug A 25mg`=80)
CATS<-c("Headache","Nausea","Fatigue","Dizziness","Insomnia"); base_rates<-c(.20,.15,.25,.10,.12); names(base_rates)<-CATS
drug_mult<-c(Placebo=1.0,`Drug A 10mg`=1.3,`Drug A 25mg`=1.6); records<-list()
for(cat in CATS) for(trt in TRTS){ n_total<-N[trt]; p<-min(.9,base_rates[cat]*drug_mult[trt]); n_event<-rbinom(1,n_total,p)
  records[[length(records)+1]]<-data.frame(trt=trt,category=cat,n=n_event,pct=round(100*n_event/n_total,1),n_total=n_total,stringsAsFactors=FALSE)}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
