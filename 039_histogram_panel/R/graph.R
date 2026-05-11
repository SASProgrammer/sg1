# graph.R -- Example 039_panel: Paneled histograms. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
p<-ggplot(df,aes(x=value))+geom_histogram(bins=10,fill="#377EB8",color="white",boundary=0)+
  facet_wrap(~trt,nrow=1)+scale_x_continuous(breaks=seq(0,100,20),limits=c(0,100))+
  labs(x="Value",y="Frequency",title="Histogram of Value by Treatment (Panels)")+
  theme_classic(base_size=11)+theme(strip.text=element_text(face="bold"),plot.title=element_text(face="bold",hjust=.5))
ggsave("039_histogram_panel.pdf",plot=p,width=12,height=5); ggsave("039_histogram_panel.png",plot=p,width=12,height=5,dpi=150)
message("Saved 039_histogram_panel.pdf / .png")
