# graph.R -- Example 043b: Bar chart with 95% CI. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
p<-ggplot(df,aes(x=category,y=pct,fill=trt,ymin=ci_lo,ymax=ci_hi))+
  geom_col(position=position_dodge(.9),color="white",width=.8)+
  geom_errorbar(position=position_dodge(.9),width=.3,color="gray30")+
  scale_fill_manual(values=c("black","#377EB8","#E41A1C"))+
  scale_y_continuous(limits=c(0,70),breaks=seq(0,60,10))+
  labs(x="Adverse Event Category",y="Incidence (%)",fill=NULL,title="Incidence (%) with 95% CI by Category and Treatment")+
  theme_classic(base_size=12)+theme(axis.text.x=element_text(angle=30,hjust=1),legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("043_Barchart_with_error_bar.pdf",plot=p,width=11,height=6); ggsave("043_Barchart_with_error_bar.png",plot=p,width=11,height=6,dpi=150)
message("Saved 043_Barchart_with_error_bar.pdf / .png")
