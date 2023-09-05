require(TargetSearchData)

smp <- new('tsSample', RIfiles=tsd_rifiles(), CDFfiles=tsd_cdffiles())
lib <- ImportLibrary(file.path(tsd_data_path(), 'library.txt'))

# check for invalid usage
expect_error(ret <- FindAllPeaks(smp))
expect_error(ret <- FindAllPeaks(smp, lib))

# check for leucine (both are equivalent)
m <- c(102, 158, 232, 260)
x <- FindAllPeaks(smp, dev=1500, RI=306800, mz=m)
y <- FindAllPeaks(smp, lib, 'GC.5')
expect_equal(x, y)

# check for valine
m <- c(100, 144, 156, 218, 246)
x <- FindAllPeaks(smp, dev=2000, RI=271500, mz=m)
y <- FindAllPeaks(smp, lib, 'GC.3')
expect_equal(x, y)

# check searching by RT
source('mock_functions.R')
peak_search <- function(smp, dev, RT, mz) {
    fun <- TargetSearch:::ri_data_extract_text
    ret <- lapply(RIfiles(smp), fun, mz, c(RT-dev, RT+dev), useRT=TRUE)
    fid <- rep(seq(smp), sapply(ret, nrow))
    ret <- cbind(do.call('rbind', ret), fid=fid)
}

tmp <- tempdir()
ncfiles <- file.path(tmp, sprintf("file%d.nc4", 1:3))
smp <- new('tsSample', CDFfiles=ncfiles, ftype='text')

# repeat 10 times with random values
for(i in 1:10) {
    # write files and recover data
    data <- lapply(RIfiles(smp), mock_rifile, mz_range=c(100,200), time_range=c(200, 300), n_peaks=300, n_scans=50)

    RT <- runif(1, 200, 300)
    mz <- sample(100:200, 5)
    x <- FindAllPeaks(smp, dev=10, RT=RT, mz=mz)
    colnames(x)[1] <- 'Intensity'
    y <- peak_search(smp, dev=10, RT=RT, mz=mz)
    y <- y[, colnames(x)]
    expect_identical(x, y)
}