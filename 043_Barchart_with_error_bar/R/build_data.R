# build_data.R -- Example 043b: Bar with CI
set.seed(432); TRTS<-c("Placebo","Drug A 10mg","Drug A 25mg"); N<-80; CATS<-c("Headache","Nausea","Fatigue","Dizziness","Insomnia")
base_rates<-c(.20,.15,.25,.10,.12); names(base_rates)<-CATS; drug_mult<-c(Placebo=1,`Drug A 10mg`=1.3,`Drug A 25mg`=1.6); z<-qnorm(.975); records<-list()
for(cat in CATS) for(trt in TRTS){ p<-min(.9,base_rates[cat]*drug_mult[trt]); n_event<-rbinom(1,N,p); phat<-n_event/N
  ci_lo<-((phat+z^2/(2*N)-z*sqrt(phat*(1-phat)/N+z^2/(4*N^2)))/(1+z^2/N))*100
  ci_hi<-((phat+z^2/(2*N)+z*sqrt(phat*(1-phat)/N+z^2/(4*N^2)))/(1+z^2/N))*100
  records[[length(records)+1]]<-data.frame(trt=trt,category=cat,n=n_event,pct=round(phat*100,1),ci_lo=round(ci_lo,1),ci_hi=round(ci_hi,1),n_total=N,stringsAsFactors=FALSE)}
df<-do.call(rbind,records); write.csv(df,"test_data.csv",row.names=FALSE); message(sprintf("Generated %d rows.",nrow(df)))
