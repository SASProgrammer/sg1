# graph.R -- Example 004: Cumulative incidence (1-KM). Run build_data.R first.
library(survival); library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
fit<-survfit(Surv(time,response)~trt,data=df)
# Build cumulative incidence data manually
sf_df<-do.call(rbind,lapply(names(fit$strata),function(s){
  idx<-which(names(fit$strata)==s); st<-cumsum(c(0,fit$strata))[idx]+1; en<-cumsum(fit$strata)[idx]
  data.frame(trt=gsub("trt=","",s),time=c(0,fit$time[st:en]),cum_inc=c(0,1-fit$surv[st:en]),stringsAsFactors=FALSE)
}))
p<-ggplot(sf_df,aes(x=time,y=cum_inc,color=trt,linetype=trt))+
  geom_step(linewidth=1)+
  scale_x_continuous(limits=c(0,24),breaks=seq(0,24,4))+
  scale_y_continuous(labels=scales::percent,limits=c(0,1.05))+
  labs(x="Time (Months)",y="Cumulative Response (%)",color=NULL,linetype=NULL,
       title="Cumulative Response Rate by Treatment (1 − KM)")+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  theme_classic(base_size=12)+theme(legend.position="bottom",plot.title=element_text(face="bold",hjust=.5))
ggsave("004_kaplan-meier_increasing.pdf",plot=p,width=9,height=6)
ggsave("004_kaplan-meier_increasing.png",plot=p,width=9,height=6,dpi=150)
message("Saved 004_kaplan-meier_increasing.pdf / .png")
