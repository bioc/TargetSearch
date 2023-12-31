\name{sampleRI}
\alias{sampleRI}
\title{ Sample specific RI detection }
\description{
	Return a matrix of the sample specific retention indices (RI) based on the correlating selective masses.
}
\usage{
sampleRI(samples, Lib, r_thres = 0.95, columns = NULL,
         method = "dayNorm", minPairObs = 5, showProgressBar = FALSE,
         makeReport = FALSE, pdfFile = "medianLibRep.pdf")
}

\arguments{
  \item{samples}{A \code{tsSample} object created by \code{ImportSamples} function. }
  \item{Lib}{  A \code{tsLib} object created by \code{\link{ImportLibrary}} function with corrected RI values.
	See \code{medianRILib}. }
  \item{r_thres}{ A correlation threshold. }
  \item{columns}{Either \code{NULL}, a \code{character} vector, or an \code{integer} vector. In
    most cases, leave it as \code{NULL}. This parameter is used to configure the column names or
    positions of RI text files. See the documentation on the \code{\link{text2bin}} function for
    further details.}
  \item{method}{ Normalization method. Options are \code{"dayNorm"}, a day based median
	normalization, \code{"medianNorm"}, normalization using the median of all the intensities
	of a given mass, and \code{"none"}, no normalization at all. }
  \item{minPairObs}{ Minimum number of pair observations. Correlations between two variables are
	computed using all complete pairs of observations in those variables. If the number
	of observations is too small, you may get high correlations values just by chance,
	so this parameters is used to avoid that. Cannot be set lower than 5. }
  \item{showProgressBar}{Logical. Should the progress bar be displayed?}
  \item{makeReport}{ Logical. If \code{TRUE} will report the RI deviations for every metabolite
	in the library. }
  \item{pdfFile}{ The file name where the report will be saved. }
}
\value{
	A matrix of correlating selective masses RI. Columns represent samples and rows
	the median RI of the selective masses. 
}
\examples{
require(TargetSearchData)
data(TSExample)

# get RI file path
RI.path <- tsd_data_path()
# update RI file path
RIpath(sampleDescription) <- RI.path
# Import Library
refLibrary        <- ImportLibrary(tsd_file_path('library.txt'))

# get the sample RI
corRI <- sampleRI(sampleDescription, refLibrary, r_thres = 0.95)

# same as above, but changing the correlation threshold and the minimum number
# of observations
corRI <- sampleRI(sampleDescription, refLibrary, r_thres = 0.9,
			minPairObs = 10)
	
}
\author{Alvaro Cuadros-Inostroza, Matthew Hannah, Henning Redestig}
\seealso{
  \code{\link{ImportSamples}}, \code{\link{ImportLibrary}},
  \code{\link{medianRILib}},  \code{\linkS4class{tsLib}},  \code{\linkS4class{tsSample}}
}
