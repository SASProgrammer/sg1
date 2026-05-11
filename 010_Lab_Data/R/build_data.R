# build_data.R  --  Example 010: Basic laboratory data time-series plot

set.seed(10)
N_SUBJ <- 60; TRTS <- c("Placebo","Drug A 10mg","Drug A 25mg")
VISITS <- 1:8

trt_traj <- list(
  Placebo      = c(28,28,29,29,30,30,30,29),
  `Drug A 10mg`= c(28,29,31,33,34,34,33,32),
  `Drug A 25mg`= c(28,31,36,41,43,44,42,40)
)

records <- list(); subj_n <- 1L
for (trt in TRTS) {
  means <- trt_traj[[trt]]
  for (i in seq_len(N_SUBJ)) {
    subj_re <- rnorm(1,0,4)
    for (vis_idx in seq_along(VISITS)) {
      vis <- VISITS[vis_idx]
      if (vis>4 && runif(1)<0.08) next
      records[[length(records)+1]] <- data.frame(
        subjid=sprintf("S%04d",subj_n),trt=trt,visit=vis,
        lbresult=round(means[vis_idx]+subj_re+rnorm(1,0,7),2),
        stringsAsFactors=FALSE)
    }
    subj_n <- subj_n+1L
  }
}
df <- do.call(rbind,records)
write.csv(df,"test_data.csv",row.names=FALSE)
message(sprintf("Generated %d rows.",nrow(df)))
