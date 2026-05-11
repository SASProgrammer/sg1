# graph.R -- Example 053: KM styled for PowerPoint (dark background). Run build_data.R first.
library(survival); library(ggplot2); library(survminer)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
fit<-survfit(Surv(time,event)~trt,data=df)

# Standard B&W PDF
p_bw<-ggsurvplot(fit,data=df,palette=c("black","#377EB8","#E41A1C"),conf.int=TRUE,
  legend.title="",xlab="Time (Months)",ylab="Survival Probability",
  title="KM Survival Estimates by Treatment",xlim=c(0,24),break.x.by=4,
  ggtheme=theme_classic(base_size=12))
ggsave("053_windows_kaplan_meier_1.pdf",plot=print(p_bw),width=9,height=6)

# Dark-background "PowerPoint" PNG
p_ppt<-ggsurvplot(fit,data=df,palette=c("white","yellow","cyan"),conf.int=FALSE,
  legend.title="",xlab="Time (Months)",ylab="Survival Probability (%)",
  title="KM Survival Estimates by Treatment",xlim=c(0,24),break.x.by=4,
  ggtheme=theme_classic(base_size=13)+
    theme(plot.background=element_rect(fill="#0000DC",color=NA),
          panel.background=element_rect(fill="#0000DC",color=NA),
          text=element_text(color="white"),axis.text=element_text(color="white"),
          axis.line=element_line(color="white"),axis.ticks=element_line(color="white"),
          legend.background=element_rect(fill="#0000DC"),legend.text=element_text(color="white"),
          plot.title=element_text(color="white",face="bold",hjust=.5)))
ggsave("053_windows_kaplan_meier_1_ppt.png",plot=print(p_ppt),width=10,height=7,dpi=150)
message("Saved 053_windows_kaplan_meier_1.pdf / _ppt.png")
