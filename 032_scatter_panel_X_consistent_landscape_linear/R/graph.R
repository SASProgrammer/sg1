# graph.R -- Example 032: Scatter panels, consistent X, landscape. Run build_data.R first.
library(ggplot2); library(dplyr)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
cors<-df|>group_by(panel)|>summarise(r=round(cor(x_val,y_val),2),.groups="drop")
df<-left_join(df,cors,by="panel")|>mutate(panel_label=sprintf("%s (r=%.2f)",panel,r))
p<-ggplot(df,aes(x=x_val,y=y_val,color=trt,shape=trt))+
  geom_point(alpha=.7,size=1.5)+
  geom_smooth(aes(group=1),method="lm",se=FALSE,color="black",linetype="dashed",linewidth=.9)+
  facet_wrap(~panel_label,nrow=1,scales="free_y")+  # X consistent, Y free
  coord_cartesian(xlim=range(df$x_val))+
  labs(x="Baseline (x)",y="Endpoint (y)",color=NULL,shape=NULL,title="Scatter Panels — Consistent X (Landscape)")+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  theme_classic(base_size=11)+theme(legend.position="bottom",strip.text=element_text(face="bold"),plot.title=element_text(face="bold",hjust=.5))
ggsave("032_scatter_panel_X_consistent_landscape_linear.pdf",plot=p,width=14,height=6)
ggsave("032_scatter_panel_X_consistent_landscape_linear.png",plot=p,width=14,height=6,dpi=150)
message("Saved 032.")
