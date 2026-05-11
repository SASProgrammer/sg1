# graph.R  --  Example 008: Mean panels in 2x2 matrix layout
# Panels: HGB early, HGB late, Creatinine, ALT.
# Run build_data.R first.

library(ggplot2)
library(dplyr)
library(patchwork)  # install.packages("patchwork") if needed

df <- read.csv("test_data.csv", stringsAsFactors = FALSE)

alpha <- 0.05

make_panel <- function(data, ylabel) {
  stats_df <- data |>
    group_by(trt, week) |>
    summarise(n=n(), center=mean(result,na.rm=TRUE),
              sem=sd(result,na.rm=TRUE)/sqrt(n()), .groups="drop") |>
    mutate(t_crit=qt(1-alpha/2,df=pmax(n-1,1)),
           q1=center-sem*t_crit, q3=center+sem*t_crit)

  ggplot(stats_df, aes(x=week,y=center,color=trt,shape=trt,group=trt,linetype=trt)) +
    geom_errorbar(aes(ymin=q1,ymax=q3),width=0,linewidth=0.8) +
    geom_line(linewidth=0.8) + geom_point(size=2.5) +
    scale_x_continuous(breaks=c(0,4,8,12,16,24)) +
    labs(x="Week", y=ylabel, color=NULL, shape=NULL, linetype=NULL) +
    theme_classic(base_size=10) +
    theme(legend.position="none")
}

p1 <- make_panel(df[df$labtest=="Hemoglobin" & df$week<=12,], "Hemoglobin (Early)")
p2 <- make_panel(df[df$labtest=="Hemoglobin" & df$week>=12,], "Hemoglobin (Late)")
p3 <- make_panel(df[df$labtest=="Creatinine",], "Creatinine")
p4 <- make_panel(df[df$labtest=="ALT",], "ALT")

# Shared legend from one panel
legend_plot <- make_panel(df[df$labtest=="ALT",], "") +
  theme(legend.position="bottom")
legend_grob <- cowplot::get_legend(legend_plot)

combined <- (p1 | p2) / (p3 | p4)
final <- combined + plot_annotation(
  title = "Mean Lab Results — Panel Matrix Layout",
  theme = theme(plot.title = element_text(face="bold", hjust=0.5))
)

ggsave("008_mean_panel_matrix.pdf", plot=final, width=12, height=9)
ggsave("008_mean_panel_matrix.png", plot=final, width=12, height=9, dpi=150)
message("Saved 008_mean_panel_matrix.pdf / .png")
