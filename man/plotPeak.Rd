\name{plotPeak}
\alias{plotPeak}
\title{ Plot peaks }
\description{
	Plot a peak of a given metabolite in a given sample showing the search windows.
}
\usage{
plotPeak(samples, Lib, metProf, rawpeaks, which.smp=1, which.met=1,
	massRange=c(85,500), corMass=FALSE)
}
\arguments{
  \item{samples}{A \code{tsSample} object created by \code{ImportSamples} function.}
  \item{Lib}{A \code{tsLib} object created by \code{\link{ImportLibrary}} function.}
  \item{metProf}{A metabolite profile object. See \code{\link{Profile}}}
  \item{rawpeaks}{ A two component list containing the retention time and the intensity matrices.
	See \code{\link{peakCDFextraction}}. }
  \item{which.smp}{ A numeric value indicating the sample. }
  \item{which.met}{ A numeric value indicating the metabolite. }
  \item{massRange}{ A two component numeric vector with the scan mass range to extract. }
  \item{corMass}{ Logical. If TRUE, show only correlating masses for the selected
	metabolite. Show all masses otherwise.}
}
\note{This function was completely rewritten. For the old function, see \code{\link{plotPeakSimple}}}
\value{
  A two component list containing the retention time and the intensity matrices. This
  list can be recycled as the 'rawpeaks' parameter for further plots (for example in a loop),
  so the CDF file doesn't need to be read again.
}
\examples{
require(TargetSearchData)
data(TargetSearchData)

# update CDF and RI paths
CDFpath(sampleDescription) <- file.path(.find.package("TargetSearchData"), "gc-ms-data")
RIpath(sampleDescription) <- file.path(.find.package("TargetSearchData"), "gc-ms-data")

# Plot the peak "Valine" for sample number 1
grep("Valine", libName(refLibrary)) # answer: 3

# plot peak from the cdf file. The rawpeaks object can be recycled in order to plot
# other metabolites.
rawpeaks <- plotPeak(sampleDescription, refLibrary, metabProfile, which.smp=1,
        which.met=3, massRange=c(85,500), corMass=FALSE)
}
\author{Alvaro Cuadros-Inostroza, Matthew Hannah, Henning Redestig }
\seealso{\code{\link{plotPeakSimple}}, \code{\link{RIcorrect}}, \code{\linkS4class{tsMSdata}}, \code{\linkS4class{tsRim}},
\code{\link{peakCDFextraction}}, \code{\link{matplot}} }
\keyword{ hplot }
