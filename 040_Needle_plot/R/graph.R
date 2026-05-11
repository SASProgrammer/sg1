# graph.R -- Example 040: Needle plot. Run build_data.R first.
library(ggplot2); library(dplyr)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)|>mutate(subj_idx=row_number())
p<-ggplot(df,aes(x=subj_idx,xend=subj_idx,y=0,yend=pct_change,color=trt))+
  geom_segment(linewidth=.8)+geom_hline(yintercept=0,linewidth=.6,linetype="dashed")+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  scale_y_continuous(breaks=seq(-100,100,20),limits=c(-100,105))+
  labs(x="Subject (grouped by treatment)",y="% Change from Baseline",color=NULL,title="Needle Plot: % Change from Baseline")+
  theme_classic(base_size=12)+theme(axis.text.x=element_blank(),axis.ticks.x=element_blank(),
    legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("040_Needle_plot.pdf",plot=p,width=12,height=6); ggsave("040_Needle_plot.png",plot=p,width=12,height=6,dpi=150)
message("Saved 040_Needle_plot.pdf / .png")
