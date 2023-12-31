% NOT generated by roxygen2
% please edit documentation here
\name{ncdf4_plot_peak}
\alias{ncdf4_plot_peak}
\title{Plot peaks from ncdf4 files}
\usage{
ncdf4_plot_peak(obj, massValues, timeRange, useRT = TRUE, showRT = useRT, plot = TRUE, ...)
}
\arguments{
    \item{obj}{Either a \code{\linkS4class{tsSample}} object or a path to NetCDF format 4 files.}
    \item{massValues}{A numeric vector representing \emph{m/z} values.}
    \item{timeRange}{A numeric vector of length 2 representing the lower and upper time limits.}
    \item{useRT}{Logical. If \code{TRUE} (default), the time range is expressed in seconds,
        otherwise if \code{FALSE}, the time range is in retention time index units. This requires
        retention time corrected CDF files or an error will be raised.}
    \item{showRT}{Logical. Whether the \emph{x}-axis of the resulting plot should represent seconds
        (\code{TRUE}) or retention index units (\code{FALSE}). This allows, for example, to search
        for a time range in seconds and display a graph in index units.}
    \item{plot}{Logical. If \code{FALSE} nothing is plotted. This option may be used to simply
        extract the data from the CDF files, but see also \code{\link{ncdf4_data_extract}}.}
    \item{\dots}{Extra arguments, such as \code{pch}, \code{col}, ..., to be passed to the plotting
        functions. See details below.}
}
\description{
    A simple function to plot \emph{m/z} ion traces from a CDF-4 file. This new interface supersedes
    the function \code{\link{plotPeakSimple}} (but that can be used for CDF-3 files).
}
\details{
    The function takes a list of path to CDF-4 files or an object of class \code{\linkS4class{tsSample}}
    as input; a list a \emph{m/z} values to select for; and a time range, which can be in seconds
    (default) or retention time index (RI) units. For the RI units to work, the CDF files must
    have been previously time corrected (See \code{\link{RIcorrect}}, \code{\link{updateRI}}).

    The selection of the time range units depends on the parameter \code{useRT}. If \code{TRUE},
    then the search will be restricted to the specified range in seconds, otherwise RI units
    will be used. However, the displayed time units are defined by the parameter \code{showRT}.
    The default behavior is to use the same time units that were search for, but using seconds to
    search and RI units to display is possible by setting \code{showRT = !useRT} (or the reverse).
    This is useful if the retention time correction was not performed correctly and you want
    to verify what retention time correspond to what retention index.

    The logical parameter \code{plot} controls whether a plot is drawn. This might be useful
    for simply extracting the data used for the plot and not caring about the plot itself. The function
    \code{\link{ncdf4_data_extract}} can be used for that purpose as well (in fact that function
    is run under the hood).

    Plot styling can be achieved by passing plotting extra parameters such as \code{col}, \code{pch},
    \code{lty}, and others (see \code{\link[graphics]{par}} and \code{\link[base]{plot}}).
    There is however a caveat due to how this function is implemented: the function calls
    \code{\link[graphics:matplot]{matlines}} once per each file (or sample), so parameters
    such as \code{col}, \code{lty}, etc., apply only to the \emph{m/z} values, not to the samples.

    If you want to display different color lines for different samples (for example), add a \sQuote{s}
    to the respective parameter name as a prefix. Currently, these parameters are allowed:
    \code{scol}, \code{stype}, \code{slty}, \code{slwd}, \code{spch}, \code{sbg}, \code{scex}.
    See the examples below for details.

    Finally, all plotting parameters are cycled over and in case of conflicts, the \sQuote{s} parameters
    take precedence.
}
\note{
    This function is only for CDF-4 files. Use the method \code{\link{ncdf4Convert}} or the function
    \code{\link{ncdf4_convert}} for conversion of CDF-3 files. You may also use function
    \code{\link{plotPeakSimple}} if you don't want to convert the files.

    Not all graphical parameters passed by \code{\dots} will work, in particular
    \code{panel.first} and \code{panel.last} are known to \emph{not} work.
    Therefore, for more personalized plots, it is recommended to set \code{plot=FALSE}
    and use the returned data for plotting.
}
\examples{

require(TargetSearchData)

# load CDF files, convert them and save them in a temporary directory
dest <- tempdir()
cdf <- tsd_cdffiles()[1:3]
cdf <- sapply(cdf, function(x) ncdf4_convert(x, outFile=file.path(dest, basename(x))))

# plot single m/z on many cdf files
ncdf4_plot_peak(cdf, massValues=c(144), timeRange=c(255, 265))
# add some style (note the usage of `slty` and `scol`)
ncdf4_plot_peak(cdf, massValues=c(144), timeRange=c(255, 265), scol=1:3, slty=1:3,
                main='Example Plot')

# plot many m/z on single cdf file (colors are set by matlines)
ncdf4_plot_peak(cdf[1], massValues=c(144, 145, 100, 218), timeRange=c(255, 265))
# add some styling (here simply use `lty` and `col`)
ncdf4_plot_peak(cdf[1], massValues=c(144, 145, 100, 218), timeRange=c(255, 265),
               col=1:4, lty=1, main='Example Plot')

# multiple m/z and files is possible but it gets messy
ncdf4_plot_peak(cdf, massValues=c(144, 145, 218), timeRange=c(255, 265),
               scol=1:3, main='Example Plot')

# do not plot anything and just get the data
z <- ncdf4_plot_peak(cdf, massValues=c(144, 145, 218), timeRange=c(255, 265), plot=FALSE)
str(z)

# using a tsSample object can achieve the same results
smp <- ImportSamplesFromDir(dest)
ncdf4_plot_peak(smp, massValues=c(144), timeRange=c(255, 265))

}
\value{
    Either a named list, one element per sample or CDF file, or \code{\link[base]{invisible}}.
    Each element is in itself a list with the following components (same as the output of
    \code{\link{ncdf4_data_extract}}).
    \itemize{
        \item \code{Time} Numeric vector: the retention time in seconds
        \item \code{Index} Numeric vector: the retention time index (or zero if the file was
                was not retention time corrected
        \item \code{Intensity} Matrix: Rows are the retention times (or scans) and columns are masses.
        \item \code{massRange} Numeric vector of length 2: the mass range of the CDF
    }
}
\seealso{
    \code{\link{plotPeak}},
    \code{\link{plotPeakSimple}},
    \code{\link{ncdf4_data_extract}},
    \code{\link{RIcorrect}},
    \code{\link{updateRI}}
}
\author{Alvaro Cuadros-Inostroza}
% vim: set ts=4 sw=4 et:
