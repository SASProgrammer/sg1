# graph.R -- Example 003: KM with Sidak simultaneous CI. Run build_data.R first.
library(survival); library(ggplot2); library(survminer)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
k<-length(unique(df$trt)); alpha_sidak<-1-(1-0.05)^(1/k)
fit<-survfit(Surv(time,event)~trt,data=df,conf.int=1-alpha_sidak)
p<-ggsurvplot(fit,data=df,palette=c("black","#377EB8","#E41A1C"),conf.int=TRUE,
  legend.title="",xlab="Time (Months)",ylab="Survival Probability",
  title=sprintf("KM Survival with Sidak CI (α*=%.4f)",alpha_sidak),
  xlim=c(0,24),break.x.by=4,ggtheme=theme_classic(base_size=12))
ggsave("003_kaplan-meier_sidak.pdf",plot=print(p),width=9,height=6)
ggsave("003_kaplan-meier_sidak.png",plot=print(p),width=9,height=6,dpi=150)
message("Saved 003_kaplan-meier_sidak.pdf / .png")
