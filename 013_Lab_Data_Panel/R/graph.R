# graph.R -- Example 013: Paneled lab data. Run build_data.R first.
library(ggplot2); library(dplyr)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE); alpha<-0.05
stats_df<-df|>group_by(labtest,trt,visit)|>
  summarise(n=n(),center=mean(lbresult,na.rm=TRUE),sem=sd(lbresult,na.rm=TRUE)/sqrt(n()),.groups="drop")|>
  mutate(t_crit=qt(1-alpha/2,df=pmax(n-1,1)),q1=center-sem*t_crit,q3=center+sem*t_crit)
p<-ggplot(stats_df,aes(x=visit,y=center,color=trt,shape=trt,group=trt,linetype=trt))+
  geom_errorbar(aes(ymin=q1,ymax=q3),width=0,linewidth=.8)+
  geom_line(linewidth=.8)+geom_point(size=3)+
  facet_wrap(~labtest,nrow=1,scales="free_y")+
  scale_x_continuous(breaks=1:8)+
  labs(x="Study Visit",y="Mean Result (95% CI)",title="Mean Lab Results — Paneled",color=NULL,shape=NULL,linetype=NULL)+
  theme_classic(base_size=11)+theme(legend.position="top",strip.text=element_text(face="bold"),plot.title=element_text(face="bold",hjust=.5))
ggsave("013_Lab_Data_Panel.pdf",plot=p,width=14,height=6)
ggsave("013_Lab_Data_Panel.png",plot=p,width=14,height=6,dpi=150)
message("Saved 013_Lab_Data_Panel.pdf / .png")
