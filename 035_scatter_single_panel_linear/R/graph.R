# graph.R -- Example 035: Single scatter with linear regression. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
fit<-lm(y_val~x_val,data=df); r<-cor(df$x_val,df$y_val)
p<-ggplot(df,aes(x=x_val,y=y_val,color=trt,shape=trt))+
  geom_point(alpha=.7,size=2)+
  geom_smooth(data=df,aes(x=x_val,y=y_val),method="lm",se=FALSE,color="black",linetype="dashed",linewidth=1,inherit.aes=FALSE)+
  labs(x="Baseline Value (x)",y="Follow-up Value (y)",color=NULL,shape=NULL,
       title=sprintf("Scatter Plot: Baseline vs. Follow-up (r=%.2f)",r))+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  theme_classic(base_size=12)+theme(legend.position="top",plot.title=element_text(face="bold",hjust=.5))
ggsave("035_scatter_single_panel_linear.pdf",plot=p,width=8,height=7)
ggsave("035_scatter_single_panel_linear.png",plot=p,width=8,height=7,dpi=150)
message("Saved 035_scatter_single_panel_linear.pdf / .png")
