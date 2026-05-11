# build_data.R  --  Example 005: Mean +/- 95% CI time-series plot
# Generates synthetic longitudinal test data and saves to test_data.csv.

set.seed(42)

N_SUBJ <- 60
TRTS   <- c("Placebo", "Drug A 10mg", "Drug A 25mg")
WEEKS  <- c(0, 4, 8, 12, 16, 24)

trt_effects <- list(
  "Placebo"      = c(50, 51, 52, 52, 53, 53),
  "Drug A 10mg"  = c(50, 46, 42, 40, 39, 38),
  "Drug A 25mg"  = c(50, 43, 37, 33, 31, 30)
)

records <- list()
subj_n  <- 1L

for (trt in TRTS) {
  means <- trt_effects[[trt]]
  for (i in seq_len(N_SUBJ)) {
    subj_re <- rnorm(1, 0, 5)
    for (wk_idx in seq_along(WEEKS)) {
      wk <- WEEKS[wk_idx]
      # ~10% dropout after week 8
      if (wk > 8 && runif(1) < 0.10) next
      score <- means[wk_idx] + subj_re + rnorm(1, 0, 8)
      records[[length(records) + 1]] <- data.frame(
        subjid = sprintf("S%04d", subj_n),
        trt    = trt,
        week   = wk,
        score  = round(score, 2),
        stringsAsFactors = FALSE
      )
    }
    subj_n <- subj_n + 1L
  }
}

df <- do.call(rbind, records)
write.csv(df, "test_data.csv", row.names = FALSE)
message(sprintf("Generated %d rows across %d subjects.", nrow(df), length(unique(df$subjid))))
print(aggregate(score ~ trt + week, data = df, FUN = function(x) round(mean(x), 2)))
