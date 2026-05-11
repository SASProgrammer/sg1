# graph.R -- Example 030: Subject disposition stacked bar. Run build_data.R first.
library(ggplot2)
df<-read.csv("test_data.csv",stringsAsFactors=FALSE)
df$disposition_cat<-factor(df$disposition_cat,levels=rev(c("Completed","Withdrew Consent","Adverse Event","Lost to Follow-up")))
p<-ggplot(df,aes(x=trt,y=pct,fill=disposition_cat))+geom_col(color="white",width=.7)+
  geom_text(aes(label=ifelse(pct>4,paste0(pct,"%"),"")),position=position_stack(vjust=.5),color="white",fontface="bold",size=4)+
  scale_fill_manual(values=c("Lost to Follow-up"="#e74c3c","Adverse Event"="#e67e22","Withdrew Consent"="#f1c40f","Completed"="#2ecc71"),name="Disposition")+
  scale_y_continuous(breaks=seq(0,100,20),limits=c(0,105))+
  labs(x=NULL,y="Subjects (%)",title="Subject Disposition by Treatment")+
  theme_classic(base_size=12)+theme(legend.position="right",plot.title=element_text(face="bold",hjust=.5))
ggsave("030_subject_disposition_with_cumulative_percent.pdf",plot=p,width=9,height=7)
ggsave("030_subject_disposition_with_cumulative_percent.png",plot=p,width=9,height=7,dpi=150)
message("Saved 030_subject_disposition_with_cumulative_percent.pdf / .png")
