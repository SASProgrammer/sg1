# build_data.R  --  Example 001: Basic Kaplan-Meier survival curve

set.seed(1)
N_SUBJ <- 50; STUDY_END <- 24.0
TRTS   <- c("Placebo", "Drug A 10mg", "Drug A 25mg")
hazard <- c(Placebo=0.08, `Drug A 10mg`=0.05, `Drug A 25mg`=0.03)

records <- list(); subj_n <- 1L
for (trt in TRTS) {
  rate <- hazard[trt]
  for (i in seq_len(N_SUBJ)) {
    time_event  <- rexp(1, rate)
    time_censor <- runif(1, STUDY_END * 0.6, STUDY_END)
    time_obs    <- min(time_event, time_censor, STUDY_END)
    event       <- as.integer(time_event <= time_censor & time_event <= STUDY_END)
    records[[length(records)+1]] <- data.frame(
      subjid=sprintf("S%04d",subj_n), trt=trt,
      time=round(time_obs,2), event=event, stringsAsFactors=FALSE)
    subj_n <- subj_n + 1L
  }
}
df <- do.call(rbind, records)
write.csv(df, "test_data.csv", row.names=FALSE)
message(sprintf("Generated %d rows.", nrow(df)))
print(aggregate(event ~ trt, data=df, FUN=sum))
