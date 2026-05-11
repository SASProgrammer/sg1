# graph.R -- Example 050: Change QTcB vs concentration. Run build_data.R first.
library(ggplot2); df<-read.csv("test_data.csv",stringsAsFactors=FALSE); r<-round(cor(df$conc,df$chg_qtcb),2)
p<-ggplot(df,aes(x=conc,y=chg_qtcb,color=trt,shape=trt))+geom_point(alpha=.7,size=2)+
  geom_smooth(data=df,aes(x=conc,y=chg_qtcb),method="lm",se=FALSE,color="black",linetype="dashed",linewidth=1,inherit.aes=FALSE)+
  geom_hline(yintercept=c(0,10,20),linetype="dotted",color=c("gray50","orange","red"),linewidth=.7)+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  labs(x="Drug Concentration (ng/mL)",y="Change in QTcB (ms)",color=NULL,shape=NULL,title=sprintf("Change in QTcB vs. Drug Concentration (r=%.2f)",r))+
  theme_classic(base_size=12)+theme(legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("050_chg_qtcb_vs_serum.pdf",plot=p,width=9,height=7); ggsave("050_chg_qtcb_vs_serum.png",plot=p,width=9,height=7,dpi=150)
message("Saved 050_chg_qtcb_vs_serum.pdf / .png")
