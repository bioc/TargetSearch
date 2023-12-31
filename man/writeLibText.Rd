\name{writeLibText}
\alias{writeLibText}
\title{Save a library object in text format}
\description{
  This function creates tab delimited text file with library information.
  The created file can be re-imported with the \code{\link{ImportLibrary}}
  function.
}
\usage{
writeLibText(lib, file)
}
\arguments{
  \item{lib}{ A \code{tsLib} object. A metabolite library. }
  \item{file}{ A string naming the output file. }
}
\examples{
require(TargetSearchData)
# get the reference library file
lib.file  <- tsd_file_path("library.txt")

# Import the reference library
refLibrary <- ImportLibrary(lib.file)

# save it to a file
writeLibText(refLibrary, file="libraryCopy.txt")

}

\author{Alvaro Cuadros-Inostroza}
\seealso{\code{\linkS4class{tsLib}}, \code{\link{ImportLibrary}} }
