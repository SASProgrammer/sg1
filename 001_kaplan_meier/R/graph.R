# graph.R  --  Example 001: Basic Kaplan-Meier survival curve
# Uses survival + ggplot2 + ggfortify (or survminer).
# Run build_data.R first.
# Install: install.packages(c("survival","ggplot2","survminer"))

library(survival)
library(ggplot2)

if (!requireNamespace("survminer", quietly=TRUE)) {
  stop("Install survminer: install.packages('survminer')")
}
library(survminer)

df <- read.csv("test_data.csv", stringsAsFactors=FALSE)

fit <- survfit(Surv(time, event) ~ trt, data=df)

p <- ggsurvplot(
  fit,
  data           = df,
  palette        = c("black","#377EB8","#E41A1C"),
  conf.int       = TRUE,
  risk.table     = FALSE,
  legend.title   = "",
  xlab           = "Time (Months)",
  ylab           = "Survival Probability",
  title          = "Kaplan-Meier Survival Estimates by Treatment",
  xlim           = c(0, 24),
  break.x.by    = 4,
  ggtheme        = theme_classic(base_size=12),
  font.title     = c(13, "bold"),
  font.x         = c(12, "bold"),
  font.y         = c(12, "bold"),
  legend         = "right"
)

ggsave("001_kaplan_meier.pdf", plot=print(p), width=9, height=6)
ggsave("001_kaplan_meier.png", plot=print(p), width=9, height=6, dpi=150)
message("Saved 001_kaplan_meier.pdf / .png")
