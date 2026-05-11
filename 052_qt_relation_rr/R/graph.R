# graph.R -- Example 052: QT vs RR relationship. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE); r<-round(cor(df$rr_interval,df$qt_interval),2)
rr_ref<-data.frame(rr=seq(600,1200,5)); rr_ref$qt_bazett<-450*sqrt(rr_ref$rr/1000)
p<-ggplot(df,aes(x=rr_interval,y=qt_interval,color=trt,shape=trt))+geom_point(alpha=.7,size=2)+
  geom_smooth(data=df,aes(x=rr_interval,y=qt_interval),method="lm",se=FALSE,color="black",linetype="dashed",linewidth=1,inherit.aes=FALSE)+
  geom_line(data=rr_ref,aes(x=rr,y=qt_bazett),color="black",linetype="dotdash",linewidth=1,inherit.aes=FALSE)+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  scale_x_continuous(limits=c(600,1200),breaks=seq(600,1200,100))+
  labs(x="RR Interval (ms)",y="QT Interval (ms)",color=NULL,shape=NULL,title=sprintf("QT vs. RR Interval (r=%.2f)",r))+
  annotate("text",x=1150,y=450*sqrt(1.15),label="Bazett\nQTcB=450",size=3,hjust=0,color="black")+
  theme_classic(base_size=12)+theme(legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("052_qt_relation_rr.pdf",plot=p,width=9,height=7); ggsave("052_qt_relation_rr.png",plot=p,width=9,height=7,dpi=150)
message("Saved 052_qt_relation_rr.pdf / .png")
