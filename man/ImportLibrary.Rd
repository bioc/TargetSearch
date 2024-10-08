\name{ImportLibrary}
\alias{ImportLibrary}
\alias{ImportLibrary.msp}
\alias{ImportLibrary.tab}
\title{ Library import }
\description{
    These functions import a metabolite library file that will be used to processed
    the GC-MS data. Two file formats are supported: a tab-delimited format and the
    more common NIST MSP format.
}
\usage{
ImportLibrary(x, type = c("auto", "tab", "msp"), ...)

ImportLibrary.tab(libfile, fields = NULL, RI_dev = c(2000,1000,200),
    SelMasses = 5, TopMasses = 15, ExcludeMasses = NULL,
    libdata, file.opt=NULL)

ImportLibrary.msp(libfile, fields = NULL, RI_dev = c(2000,1000,200),
    SelMasses = 5, TopMasses = 15, ExcludeMasses = NULL)

}
\arguments{
  \item{x}{A character string or a \code{data.frame}. If \code{data.frame},
    it will be passed to \code{ImportLibrary.tab} as parameter \code{libdata}.
    If \code{character}, it will be passed as \code{libfile} to either
    \code{ImportLibrary.tab} or \code{ImportLibrary.msp} according to the file
    type (option \code{type}).}
  \item{libfile}{A character string naming a library file. See details.}
  \item{type}{The library file format. Possible options are \code{"tab"} for a
  tab-delimited file, \code{"msp"} for NIST MSP format, or \code{"auto"} for
  autodetection. Default to \code{"auto"}.}
  \item{fields}{A two component list. Each component contains a regular
  expression used to parse and extract the fields for retention index and
  selection masses. Only meaningful for MSP format.}
  \item{RI_dev}{ A three component vector with RI windows. }
  \item{SelMasses}{ The number of selective masses that will be used. }
  \item{TopMasses}{ The number of most intensive masses that will be taken from the spectrum,
    if no \code{TOP_MASS} is provided.}
  \item{ExcludeMasses}{ Optional. A vector containing a list of masses that will be excluded.}
  \item{libdata}{Optional. A data frame with library data. The format is the same
    as the library file. It is equivalent to importing the library file first
    with \code{\link[utils]{read.table}} and calling \code{ImportLibrary.tab} after.
    This might be preferable for "fine tuning", for example, if the library file
    is in CSV format instead of tab-delimited.}
  \item{file.opt}{Optional. A list containing arguments to be passed to
    \code{\link[utils]{read.table}}.}
  \item{\dots}{Further arguments passed to \code{ImportLibrary.tab} or \code{ImportLibrary.msp}}
}
\details{

    \code{ImportLibrary} is a wrapper for functions \code{ImportLibrary.tab} and
    \code{ImportLibrary.msp} which detects automatically which function should be
    called.

    \code{ImportLibrary.tab} reads a tab delimited text file by calling the function
    \code{\link[utils]{read.table}} which will be parsed and converted to a
    \code{\linkS4class{tsLib}} object. The following arguments are used by default
    (which are not exactly the defaults for \code{read.table}):

    \code{header=TRUE, sep="\t", quote="", dec=".", fill=TRUE, comment.char="#"}

    The argument \code{file.opt} can be used to change these options. Other
    alternative is to import first the file with \code{read.table} and
    friends, and call \code{ImportLibrary} with the resulting \code{data.frame}.
    This allows more flexibility with libraries with unusual characters, for
    example.

    These columns are needed:

    \itemize{
    \item \code{libID} - A unique identifier for the metabolite.
    \item \code{Name} - The metabolite name.
    \item \code{RI} - The expected RI.
    \item \code{SEL_MASS} - A list of selective masses separated with semicolon.
    \item \code{TOP_MASS} - A list of the most abundant masses to be searched, separated
        with semicolons.
    \item \code{Win_k} - The RI windows, k = 1,2,3. Mass search is performed in three
        steps. A RI window required for each one of them.
    \item \code{SPECTRUM} - The metabolite spectrum. \emph{m/z} and intensity values
        are separated by spaces, colons or semicolons (see notes on the format below).
    \item \code{QUANT_MASS} - A list of masses that might be used for quantification.
    One value per metabolite and it must be one of the selective masses. (optional)
    }

    The columns \code{Name} and \code{RI} are mandatory. At least one of columns \code{SEL_MASS},
    \code{TOP_MASS} and \code{SPECTRUM} must be given as well. By using the
    parameters \code{SelMasses} or \code{TopMasses} it is possible to set the selective
    masses or the top masses from the spectra. The parameter \code{ExcludeMasses} is
    used only when masses are obtained from the spectra.
    The parameter \code{RI_dev} can be used to set the RI windows.
    Note that in this case, all metabolites would have the same RI windows.

    The \code{SPECTRUM} format can be a list of \emph{m/z}-intensity pairs separated
    by colons: \code{85:8 86:13 87:5 88:4 ...}, or similar to the MSP spectrum format (shown
    below): \code{85 8; 86 13; 87 5; 88 4; ...}. The internal parser is \strong{not} strict,
    so even a list of integers separated by spaces is allowed, for example,
    \code{86 8 86 13 ...}. The only restriction is that the number of integers is even,
    otherwise the input is truncated. If the spectrum is not available for some analytes,
    simply leave the respective cell empty or use \code{NA}. \strong{Note:} Only
    digits(0-9), spaces, colons(:) and semicolons(;) are allowed in this column; the
    presence of other characters will generate and error, unless it is \code{NA}.

    A unique identifier may be provided as well (\code{libID}). This could be a
    external database identifier. If it is not provided, a random identifier will be created
    of the form \code{GC.k}, k = 1,...,N.

    The MSP format is a text file that can be imported/exported from NIST. A typical
    MSP file looks like this:

\preformatted{
Name: Pyruvic Acid
Synon: Propanoic acid, 2-(methoxyimino)-, trimethylsilyl ester
Synon: RI: 223090
Synon: SEL MASS: 89|115|158|174|189
Formula: C7H15NO3Si
MW: 189
Num Peaks: 41
  85    8;  86   13;  87    5;  88    4;  89  649;
  90   55;  91   28;  92    1;  98   13;  99  257;
 100  169; 101   30; 102    7; 103   13; 104    1;
 113    3; 114   35; 115  358; 116   44; 117   73;
 118   10; 119    4; 128    2; 129    1; 130   10;
 131    3; 142    1; 143   19; 144    4; 145    1;
 157    1; 158   69; 159   22; 160    4; 173    1;
 174  999; 175  115; 176   40; 177    2; 189   16;
 190    2;

Name: another metabolite
...
}

    Different entries must be separated by empty lines. In order to parse the retention
    time index (RI) and selective masses (SEL MASS), a two component list
    containing the field names of RI and SEL_MASS must be provided by using the
    parameter \code{fields}. In this example, use \code{field = list("RI: ", "SEL MASS: ")}.
    Note that \code{ImportLibrary} expects to find those fields next to "Synon:".
    Alternatively, you could provide the RI and SEL_MASS using the \code{\linkS4class{tsLib}}
    methods.

    Libraries for TargetSearch and for different retention index systems, such
    as VAR5 or MDN35, can be downloaded from
    \url{http://gmd.mpimp-golm.mpg.de/}.
}

\value{
  A \code{tsLib} object.
}
\examples{
# get the reference library file
require(TargetSearchData)
lib.file  <- tsd_file_path("library.txt")

# Import the reference library
refLibrary <- ImportLibrary(lib.file)

# set new names for the first 3 metabolites
libName(refLibrary)[1:3] <- c("Metab01", "Metab02", "Metab03")

# change the retention time deviations of Metabolite 3
RIdev(refLibrary)[3,] <- c(3000,1500,150)

}
\author{Alvaro Cuadros-Inostroza, Matthew Hannah, Henning Redestig }
\seealso{ \code{\link{ImportSamples}}, \code{\linkS4class{tsLib}} }
