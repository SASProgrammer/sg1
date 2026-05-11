# build_data.R  --  Example 009: Mean panels in portrait layout

set.seed(9)

N_SUBJ <- 50; TRTS <- c("Placebo","Drug A 10mg","Drug A 25mg")
WEEKS  <- c(0,4,8,12,16,24); LABS <- c("Hemoglobin","Creatinine","ALT")

lab_config <- list(
  Hemoglobin=list(Placebo=c(13.5,13.4,13.3,13.3,13.2,13.2),
                  `Drug A 10mg`=c(13.5,13.6,13.8,14.0,14.0,14.1),
                  `Drug A 25mg`=c(13.5,13.8,14.2,14.5,14.6,14.7),sd=1.2),
  Creatinine=list(Placebo=c(0.9,0.91,0.92,0.92,0.93,0.93),
                  `Drug A 10mg`=c(0.9,0.92,0.95,0.97,0.98,0.98),
                  `Drug A 25mg`=c(0.9,0.95,1.00,1.05,1.07,1.08),sd=0.15),
  ALT=list(Placebo=c(28,29,29,30,30,30),`Drug A 10mg`=c(28,30,32,34,34,33),
           `Drug A 25mg`=c(28,33,38,42,43,41),sd=8)
)

records <- list(); subj_n <- 1L
for (lab in LABS) {
  cfg <- lab_config[[lab]]
  for (trt in TRTS) {
    means <- cfg[[trt]]; sd <- cfg$sd
    for (i in seq_len(N_SUBJ)) {
      subj_re <- rnorm(1,0,sd*0.4)
      for (wk_idx in seq_along(WEEKS)) {
        wk <- WEEKS[wk_idx]
        if (wk>8 && runif(1)<0.08) next
        records[[length(records)+1]] <- data.frame(
          subjid=sprintf("S%04d",subj_n),labtest=lab,trt=trt,
          week=wk,result=round(means[wk_idx]+subj_re+rnorm(1,0,sd),3),
          stringsAsFactors=FALSE)
      }
      subj_n <- subj_n+1L
    }
  }
}
df <- do.call(rbind,records)
write.csv(df,"test_data.csv",row.names=FALSE)
message(sprintf("Generated %d rows.",nrow(df)))
