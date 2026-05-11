# graph.R -- Example 041: Paneled needle plots. Run build_data.R first.
library(ggplot2); library(dplyr)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)|>group_by(trt)|>mutate(subj_idx=row_number())|>ungroup()
p<-ggplot(df,aes(x=subj_idx,xend=subj_idx,y=0,yend=pct_change))+
  geom_segment(color="#377EB8",linewidth=.7)+geom_hline(yintercept=0,linewidth=.5,linetype="dashed")+
  facet_wrap(~trt,nrow=1,scales="free_x")+
  scale_y_continuous(breaks=seq(-100,100,20),limits=c(-100,105))+
  labs(x="Subject",y="% Change from Baseline",title="Paneled Needle Plot: % Change")+
  theme_classic(base_size=11)+theme(axis.text.x=element_blank(),axis.ticks.x=element_blank(),
    strip.text=element_text(face="bold"),plot.title=element_text(face="bold",hjust=.5))
ggsave("041_Needle_panel.pdf",plot=p,width=12,height=6); ggsave("041_Needle_panel.png",plot=p,width=12,height=6,dpi=150)
message("Saved 041_Needle_panel.pdf / .png")
