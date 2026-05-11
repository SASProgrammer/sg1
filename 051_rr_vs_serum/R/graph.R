# graph.R -- Example 051: RR vs concentration. Run build_data.R first.
library(ggplot2); df<-read.csv("test_data.csv",stringsAsFactors=FALSE); r<-round(cor(df$conc,df$rr_interval),2)
p<-ggplot(df,aes(x=conc,y=rr_interval,color=trt,shape=trt))+geom_point(alpha=.7,size=2)+
  geom_smooth(data=df,aes(x=conc,y=rr_interval),method="lm",se=FALSE,color="black",linetype="dashed",linewidth=1,inherit.aes=FALSE)+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  labs(x="Drug Concentration (ng/mL)",y="RR Interval (ms)",color=NULL,shape=NULL,title=sprintf("RR Interval vs. Drug Concentration (r=%.2f)",r))+
  theme_classic(base_size=12)+theme(legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("051_rr_vs_serum.pdf",plot=p,width=9,height=7); ggsave("051_rr_vs_serum.png",plot=p,width=9,height=7,dpi=150)
message("Saved 051_rr_vs_serum.pdf / .png")
