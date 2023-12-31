`plotFAME` <-
function(samples, RImatrix, whichFAME) {
  run_days <- sampleDays(samples)
  run_starts <- (1:length(run_days))[duplicated(run_days) == FALSE]
  run_ends <- c(run_starts[-1] -1, length(samples))
  plot(RImatrix[whichFAME,], cex=0.5, xlab = "Samples", ylab = "R.T.",
		main = sprintf("RI Marker %d", whichFAME))
  abline(v=c(run_starts,length(samples)), col="red")
  text((run_starts+run_ends)/2, min(RImatrix[whichFAME,], na.rm=TRUE),run_days[duplicated(run_days) == FALSE],srt=90)
}

