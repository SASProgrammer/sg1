# graph.R -- Example 045: Vertical bar panels. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)|>(\(d){d$visit_label<-paste0("Week ",d$visit);d})()
p<-ggplot(df,aes(x=trt,y=pct,fill=trt))+geom_col(color="white",width=.8)+
  facet_wrap(~visit_label,nrow=1)+scale_fill_manual(values=c("black","#377EB8","#E41A1C"))+
  scale_y_continuous(limits=c(0,70),breaks=seq(0,60,10))+
  labs(x=NULL,y="Response Rate (%)",fill=NULL,title="Response Rate by Treatment — Panels by Visit")+
  theme_classic(base_size=11)+theme(axis.text.x=element_text(angle=30,hjust=1),legend.position="none",
    strip.text=element_text(face="bold"),plot.title=element_text(face="bold",hjust=.5))
ggsave("045_vertical_bar_chart_panel.pdf",plot=p,width=12,height=6); ggsave("045_vertical_bar_chart_panel.png",plot=p,width=12,height=6,dpi=150)
message("Saved 045_vertical_bar_chart_panel.pdf / .png")
