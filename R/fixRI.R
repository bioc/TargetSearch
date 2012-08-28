# A function to manually correct the RIs
# Deprecated! see fixRI
fixRIcorrection <- function(samples, rimLimits, RImatrix, sampleNames) {

   .Deprecated("fixRI")
   if( all( colnames(RImatrix) == sampleNames(samples) ) == FALSE) {
        stop("Sample names and columns of the RI matrix do not match")
   }

   if(is.character(sampleNames)) {
        idx <- which(sampleNames(samples) %in% sampleNames)
        if(length(idx) <= 0) {
            stop("sampleNames not found")
        }
   } else if(is.numeric(sampleNames)) {
        idx <- sampleNames
   } else {
        stop("Invalid sampleNames argument")
   }

   ri.files <- RIfiles(samples)
   standard  <- rimStandard(rimLimits)
   .fixRIfile(ri.files, RImatrix, standard, idx)
}

# function to fix the RI of the files indexed by 'idx'
.fixRIfile <- function(ri.files, RImatrix, standard, idx)
{
   for(i in idx) {
       fameTimes <- RImatrix[,i]
       message(sprintf("Correcting File %s", ri.files[i]))
       cols   <- c("SPECTRUM", "RETENTION_TIME_INDEX", "RETENTION_TIME")
       opt    <- get.file.format.opt(ri.files[i], cols)
       if(opt[1] == 0) {
           tmp    <- read.delim(ri.files[i], as.is = TRUE)
           tmp$RETENTION_TIME_INDEX <- rt2ri(tmp$RETENTION_TIME, fameTimes, standard)
           write.table(tmp, file = ri.files[i], row.names = FALSE, sep="\t", quote=FALSE)
       } else if(opt[1] == 1) {
           z <- readRIBin(ri.files[i])
           z$retIndex <- rt2ri(z$retTime, fameTimes, standard)
           writeRIBin(z, ri.files[i])
       } else {
           stop(sprintf("incorrect file format: %s", ri.files[i]))
       }
   }
}

# validate an RI matrix.
.validateRImatrix <- function(smp, rim, RImat)
{
	if(length(rimStandard(rim)) != nrow(RImat))
		stop("Invalid RI matrix: number of rows don't match rimLimit object.")
	if(length(smp) != ncol(RImat))
		stop("Invalid RI matrix: number of columns don't match tsSample object.")
	if( any(colnames(RImat) != sampleNames(smp) ))
		stop("Sample names and columns of the RI matrix do not match")
	return(TRUE)
}

# returns the index of the sampl
.sampNameIndex <- function(smp, snames)
{
	if(is.character(snames))
		which(sampleNames(smp) %in% snames)
	else if(is.numeric(snames))
		snames
	else
		stop("Invalid argument")
}

riMatrix <- function(samples, rim)
{
	ri.files <- RIfiles(samples)
	mass     <- rimMass(rim)
	std      <- rimStandard(rim)
	rLimits  <- rimLimits(rim)
	RImat    <- matrix(nrow=dim(rLimits)[1], ncol=length(ri.files))
	colnames(RImat) <- sampleNames(samples)
	rownames(RImat) <- rownames(rLimits)
	if(length(mass) == 1)
		mass <- rep(mass, dim(rLimits)[1])

	cols <- c("SPECTRUM", "RETENTION_TIME_INDEX", "RETENTION_TIME")

	useRT <- TRUE
	for (i in 1:length(ri.files)) {
		opts <- get.file.format.opt(ri.files[i], cols)
		out  <- .Call("FindPeaks", as.character(ri.files[i]),rLimits[,1],
			mass, rLimits[,2], opts, useRT, PACKAGE="TargetSearch")
		RImat[,i] <- out[[3]]
	}
	RImat
}

fixRI <- function(samples, rimLimits, RImatrix=NULL, sampleNames=NULL)
{
	if(!is.null(RImatrix))
		.validateRImatrix(samples, rimLimits, RImatrix)
	else
		RImatrix <- riMatrix(samples, rimLimits)

	idx <- seq(length(samples))
	if(!is.null(sampleNames))
		idx <- .sampNameIndex(samples, sampleNames)

	ri.files <- RIfiles(samples)
	standard  <- rimStandard(rimLimits)
	.fixRIfile(ri.files, RImatrix, standard, idx)
	invisible()
}

# vim: set ts=4 sw=4: