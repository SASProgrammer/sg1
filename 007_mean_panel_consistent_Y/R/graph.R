# graph.R  --  Example 007: Mean panels with consistent Y-axis scale
# Facets by lab test, consistent Y axis via scales="fixed".
# Run build_data.R first.

library(ggplot2)
library(dplyr)

df <- read.csv("test_data.csv", stringsAsFactors = FALSE)

alpha <- 0.05
stats_df <- df |>
  group_by(labtest, trt, week) |>
  summarise(
    n      = n(),
    center = mean(result, na.rm = TRUE),
    sem    = sd(result, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  ) |>
  mutate(
    t_crit = qt(1 - alpha / 2, df = pmax(n - 1, 1)),
    q1     = center - sem * t_crit,
    q3     = center + sem * t_crit
  )

p <- ggplot(stats_df, aes(x = week, y = center, color = trt, shape = trt, group = trt)) +
  geom_errorbar(aes(ymin = q1, ymax = q3), width = 0, linewidth = 0.8) +
  geom_line(linewidth = 0.8, aes(linetype = trt)) +
  geom_point(size = 3) +
  facet_wrap(~ labtest, nrow = 1, scales = "fixed") +
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 24)) +
  labs(
    x        = "Study Week",
    y        = "Mean Result (95% CI)",
    title    = "Mean Lab Results Over Time by Treatment (Consistent Y Axis)",
    color    = NULL, shape = NULL, linetype = NULL
  ) +
  theme_classic(base_size = 11) +
  theme(
    legend.position  = "top",
    strip.text       = element_text(face = "bold"),
    axis.title       = element_text(face = "bold"),
    plot.title       = element_text(face = "bold", hjust = 0.5)
  )

ggsave("007_mean_panel_consistent_Y.pdf", plot = p, width = 14, height = 6)
ggsave("007_mean_panel_consistent_Y.png", plot = p, width = 14, height = 6, dpi = 150)
message("Saved 007_mean_panel_consistent_Y.pdf / .png")
