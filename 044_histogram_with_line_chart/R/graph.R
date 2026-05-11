# graph.R -- Example 044: Histogram + normal density line. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
mu<-mean(df$value); sigma<-sd(df$value); bin_width<-10; n_total<-nrow(df)
p<-ggplot(df,aes(x=value))+
  geom_histogram(binwidth=bin_width,fill="lightsteelblue",color="white",boundary=0)+
  stat_function(fun=function(x) dnorm(x,mu,sigma)*n_total*bin_width,color="red",linewidth=1.5)+
  scale_x_continuous(breaks=seq(0,100,10),limits=c(0,100))+
  labs(x="Value",y="Frequency",title=sprintf("Histogram with Normal Density (μ=%.1f, σ=%.1f)",mu,sigma))+
  theme_classic(base_size=12)+theme(plot.title=element_text(face="bold",hjust=.5))
ggsave("044_histogram_with_line_chart.pdf",plot=p,width=9,height=6); ggsave("044_histogram_with_line_chart.png",plot=p,width=9,height=6,dpi=150)
message("Saved 044_histogram_with_line_chart.pdf / .png")
