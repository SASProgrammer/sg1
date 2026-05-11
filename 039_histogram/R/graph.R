# graph.R -- Example 039: Histogram. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
p<-ggplot(df,aes(x=value,fill=trt))+
  geom_histogram(bins=10,alpha=.7,position="identity",color="white",boundary=0)+
  scale_x_continuous(breaks=seq(0,100,10),limits=c(0,100))+
  scale_fill_manual(values=c("gray","#377EB8","#E41A1C"))+
  labs(x="Value",y="Frequency",fill=NULL,title="Histogram of Value by Treatment")+
  theme_classic(base_size=12)+theme(legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("039_histogram.pdf",plot=p,width=9,height=6); ggsave("039_histogram.png",plot=p,width=9,height=6,dpi=150)
message("Saved 039_histogram.pdf / .png")
