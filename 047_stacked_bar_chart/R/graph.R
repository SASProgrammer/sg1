# graph.R -- Example 047: Stacked bar chart. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
df$response_cat<-factor(df$response_cat,levels=c("Progressive Disease","Stable Disease","Partial Response","Complete Response"))
p<-ggplot(df,aes(x=trt,y=pct,fill=response_cat))+geom_col(color="white",width=.7)+
  geom_text(aes(label=ifelse(pct>4,paste0(pct,"%"),"")),position=position_stack(vjust=.5),color="white",fontface="bold",size=3.5)+
  scale_fill_manual(values=c("#e74c3c","#f39c12","#27ae60","#2ecc71"),name="Response")+
  scale_y_continuous(breaks=seq(0,100,20),limits=c(0,105))+
  labs(x=NULL,y="Percentage (%)",title="Response Categories by Treatment")+
  theme_classic(base_size=12)+theme(legend.position="right",plot.title=element_text(face="bold",hjust=.5))
ggsave("047_stacked_bar_chart.pdf",plot=p,width=9,height=6); ggsave("047_stacked_bar_chart.png",plot=p,width=9,height=6,dpi=150)
message("Saved 047_stacked_bar_chart.pdf / .png")
