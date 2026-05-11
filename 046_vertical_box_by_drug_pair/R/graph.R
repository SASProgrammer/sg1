# graph.R -- Example 046: Box plots. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
p<-ggplot(df,aes(x=trt,y=value,fill=trt))+geom_boxplot(outlier.size=1,width=.6)+
  facet_wrap(~drug_pair,nrow=1)+scale_fill_manual(values=c("#377EB8","#E41A1C"))+
  labs(x=NULL,y="Value",fill=NULL,title="Box Plot by Drug Pair and Treatment")+
  theme_classic(base_size=11)+theme(legend.position="top",strip.text=element_text(face="bold"),plot.title=element_text(face="bold",hjust=.5))
ggsave("046_vertical_box_by_drug_pair.pdf",plot=p,width=10,height=6); ggsave("046_vertical_box_by_drug_pair.png",plot=p,width=10,height=6,dpi=150)
message("Saved 046_vertical_box_by_drug_pair.pdf / .png")
