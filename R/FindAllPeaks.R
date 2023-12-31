
`FindAllPeaks` <-
function(samples, Lib, libID, dev=NULL, mz=NULL, RI=NULL, RT=NULL,
         mz_type = c('selMass', 'quantMass', 'topMass'),
         columns = NULL)
{
    assert_that(is.tsSample(samples))
    if(missing(Lib))
        Lib <- NULL
    if(!is.null_or_na(Lib))
        assert_that(is.tsLib(Lib))
    if(missing(libID))
        libID <- NULL
    if(!is.null_or_na(libID))
        assert_that(is.scalar(libID))

    useRT <- FALSE
    useLib <- !is.null_or_na(libID) && !is.null_or_na(Lib)

    if(is.null_or_na(RI)) {
        if(!is.null_or_na(RT)) {
            RI <- RT
            useRT <- TRUE
        } else if (useLib) {
            RI <- if(!is.na(medRI(Lib)[libID])) medRI(Lib)[libID] else libRI(Lib)[libID]
        } else {
            stop('Function requires either parameters 1) `RI`, or 2) `RT`, or 3) `Lib` and `libID`')
        }
    }
    assert_that(is.scalar(RI))

    if(is.null_or_na(dev)) {
        if(useRT)
            stop('Function requires the parameter `dev` if `RT` is specified')
        if(!useLib)
            stop('Parameter `dev` is required if `Lib` or `libID` are missing')
        dev <- RIdev(Lib)[libID, 1]
    }

    assert_that(is.numeric(dev), is.sod(dev))

    if(is.null_or_na(mz)) {
        method <- switch(match.arg(mz_type),
                         selMass=selMass, quantMass=quantMass, topMass=topMass)
        if(!useLib)
            stop('Parameter `mz` is required if `Lib` or `libID` are missing')
        mz <- method(Lib)[[libID]]
    }
    assert_that(is.numeric(mz))

    ref   <- switch(length(dev), cbind(minRI=RI - dev, mz=mz, maxRI=RI + dev),
                    cbind(minRI=RI + dev[1], mz=mz, maxRI=RI + dev[2]))
    peaks <- lapply(RIfiles(samples), getAllPeaks, ref, useRT=useRT, columns=columns)

    n  <- rep.int(1:length(peaks), sapply(peaks, nrow))
    pk <- do.call('rbind', peaks)
    pk <- cbind(pk, fid=n)

    rownames(pk) <- NULL
    return(pk[, c('Int', 'RI', 'RT', 'mz', 'fid'), drop=FALSE])
}

# vim: set ts=4 sw=4 et:
