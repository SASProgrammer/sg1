# graph.R -- Example 031: Scatter matrix. Run build_data.R first.
library(ggplot2); library(tidyr); library(dplyr)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
long<-pivot_longer(df,cols=c(y1,y2,y3),names_to="endpoint",values_to="y") |>
  mutate(endpoint=recode(endpoint,y1="Endpoint 1",y2="Endpoint 2",y3="Endpoint 3"))
cors<-long|>group_by(endpoint)|>summarise(r=round(cor(x_val,y),2),.groups="drop")
long<-left_join(long,cors,by="endpoint")|>mutate(panel_label=sprintf("%s (r=%.2f)",endpoint,r))
p<-ggplot(long,aes(x=x_val,y=y,color=trt,shape=trt))+
  geom_point(alpha=.7,size=1.5)+
  geom_smooth(aes(group=1),method="lm",se=FALSE,color="black",linetype="dashed",linewidth=1)+
  facet_wrap(~panel_label,nrow=1,scales="free_y")+
  labs(x="Baseline (x)",y="Endpoint Value",color=NULL,shape=NULL,title="Scatter Plot Matrix — Endpoints vs. Baseline")+
  scale_color_manual(values=c("black","#377EB8","#E41A1C"))+
  theme_classic(base_size=11)+theme(legend.position="bottom",strip.text=element_text(face="bold"),plot.title=element_text(face="bold",hjust=.5))
ggsave("031_scatter_matrix_linear.pdf",plot=p,width=14,height=6); ggsave("031_scatter_matrix_linear.png",plot=p,width=14,height=6,dpi=150)
message("Saved 031_scatter_matrix_linear.pdf / .png")
