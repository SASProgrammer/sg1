# graph.R -- Example 042: Waterfall chart. Run build_data.R first.
library(ggplot2); library(dplyr)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)|>arrange(best_pct_change)|>mutate(idx=row_number())
p<-ggplot(df,aes(x=idx,y=best_pct_change,fill=trt))+
  geom_col(width=1,color=NA)+
  geom_hline(yintercept=0,linewidth=.6)+geom_hline(yintercept=-30,linetype="dashed",color="gray50",linewidth=.8)+
  scale_fill_manual(values=c("black","#377EB8","#E41A1C"))+
  scale_y_continuous(breaks=seq(-100,100,20),limits=c(-105,105))+
  labs(x="Subject (sorted by % change)",y="Best % Change from Baseline",fill=NULL,title="Waterfall Chart: Best % Change from Baseline")+
  annotate("text",x=nrow(df)*.05,y=-33,label="−30%",color="gray50",size=3)+
  theme_classic(base_size=12)+theme(axis.text.x=element_blank(),axis.ticks.x=element_blank(),
    legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("042_Waterfall.pdf",plot=p,width=14,height=6); ggsave("042_Waterfall.png",plot=p,width=14,height=6,dpi=150)
message("Saved 042_Waterfall.pdf / .png")
