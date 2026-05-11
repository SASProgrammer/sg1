# graph.R -- Example 054: Bar chart with CI demonstrating title/footnote system. Run build_data.R first.
library(ggplot2)

# Simulate TitleKey / TNFSet system
titles    <- list(title1="Study XYZ — Gilead Sciences", title2="Protocol ABC-123",
                  title3="Figure 1. Incidence (%) of Adverse Events by Category", title4="Safety Population")
footnotes <- c("Source: 054_tnfset_titlekey_example_043.R",
               "AE=Adverse Event. CI=95% Confidence Interval (Wilson method).")

df <- read.csv("test_data.csv", stringsAsFactors=FALSE)

p <- ggplot(df, aes(x=category, y=pct, fill=trt, ymin=ci_lo, ymax=ci_hi)) +
  geom_col(position=position_dodge(.9), color="white", width=.8) +
  geom_errorbar(position=position_dodge(.9), width=.3, color="gray30") +
  scale_fill_manual(values=c("black","#377EB8","#E41A1C")) +
  scale_y_continuous(limits=c(0,75), breaks=seq(0,70,10)) +
  labs(x="Adverse Event Category", y="Incidence (%)", fill=NULL,
       title=titles$title3,
       subtitle=paste0(titles$title1, " | ", titles$title2, "\n", titles$title4),
       caption=paste(footnotes, collapse="\n")) +
  theme_classic(base_size=12) +
  theme(axis.text.x=element_text(angle=30,hjust=1), legend.position="top",
        plot.title=element_text(face="bold",hjust=.5),
        plot.subtitle=element_text(color="gray50",hjust=.5,size=9),
        plot.caption=element_text(color="gray50",hjust=0,size=8))

ggsave("054_tnfset_titlekey_example_043.pdf", plot=p, width=11, height=7)
ggsave("054_tnfset_titlekey_example_043.png", plot=p, width=11, height=7, dpi=150)
message("Saved 054_tnfset_titlekey_example_043.pdf / .png")
