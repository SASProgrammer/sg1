# graph.R -- Example 002: Paneled KM. Run build_data.R first.
library(survival); library(ggplot2); library(survminer)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
fit<-survfit(Surv(time,event)~trt+stratum,data=df)
p<-ggsurvplot_facet(fit,data=df,facet.by="stratum",palette=c("black","#377EB8","#E41A1C"),
  conf.int=TRUE,legend.title="",xlab="Time (Months)",ylab="Survival Probability",
  ggtheme=theme_classic(base_size=11),xlim=c(0,24),break.x.by=4,
  title="KM Survival by Treatment and Stratum")
ggsave("002_kaplan_meier_panel.pdf",plot=p,width=12,height=6)
ggsave("002_kaplan_meier_panel.png",plot=p,width=12,height=6,dpi=150)
message("Saved 002_kaplan_meier_panel.pdf / .png")
