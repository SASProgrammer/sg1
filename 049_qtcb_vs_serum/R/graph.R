# graph.R -- Example 049: QTcB vs concentration. Run build_data.R first.
library(ggplot2); library(dplyr)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE); r<-round(cor(df$conc,df$qtcb),2)
p<-ggplot(df,aes(x=conc,y=qtcb,color=trt,shape=trt))+
  geom_point(alpha=.7,size=2)+
  geom_smooth(data=df,aes(x=conc,y=qtcb),method="lm",se=FALSE,color="black",linetype="dashed",linewidth=1,inherit.aes=FALSE)+
  geom_hline(yintercept=450,linetype="dotted",color="gray50",linewidth=.8)+
  annotate("text",x=max(df$conc)*.95,y=453,label="450 ms",hjust=1,size=3.5,color="gray50")+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  labs(x="Drug Concentration (ng/mL)",y="QTcB (ms)",color=NULL,shape=NULL,title=sprintf("QTcB vs. Drug Concentration (r=%.2f)",r))+
  theme_classic(base_size=12)+theme(legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("049_qtcb_vs_serum.pdf",plot=p,width=9,height=7); ggsave("049_qtcb_vs_serum.png",plot=p,width=9,height=7,dpi=150)
message("Saved 049_qtcb_vs_serum.pdf / .png")
