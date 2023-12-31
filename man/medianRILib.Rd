\name{medianRILib}
\alias{medianRILib}
\title{ Median RI library correction }
\description{
Return a \code{tsLib} object with the median RI of the selective masses across samples.
}
\usage{
medianRILib(samples, Lib, makeReport = FALSE, pdfFile = "medianLibRep.pdf",
            columns = NULL, showProgressBar = FALSE)
}

\arguments{
  \item{samples}{ A \code{tsSample} object created by \code{\link{ImportSamples}} function. }
  \item{Lib}{ A \code{tsLib} object created by \code{\link{ImportLibrary}} function. }
  \item{makeReport}{ Logical. If \code{TRUE} will report the RI deviations for every metabolite
    in the library. }
  \item{pdfFile}{ The file name where the report will be saved. }
  \item{columns}{Either \code{NULL}, a \code{character} vector, or an \code{integer} vector. In
    most cases, leave it as \code{NULL}. This parameter is used to configure the column names or
    positions of RI text files. See the documentation on the \code{\link{text2bin}} function for
    further details.}
  \item{showProgressBar}{Logical. Should the progress bar be displayed?}
}
\value{
    A \code{tsLib} object. It will update the slot \code{med_RI} which contains
    the median RI of every searched metabolite.
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
# update median RI
refLibrary        <- medianRILib(sampleDescription, refLibrary)

# perhaps you need to adjust the library RI of one metabolite and the allowed time
# deviation (first time deviation window)
libRI(refLibrary)[5] <- 306500
RIdev(refLibrary)[5,1] <- 2000

refLibrary        <- medianRILib(sampleDescription, refLibrary)

}
\author{Alvaro Cuadros-Inostroza, Matthew Hannah, Henning Redestig }
\seealso{ \code{\link{ImportSamples}}, \code{\link{ImportLibrary}}, \code{\link{tsLib-class}} }
