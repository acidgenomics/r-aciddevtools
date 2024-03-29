% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/installedPackages.R
\name{installedPackages}
\alias{installedPackages}
\title{Find installed packages}
\usage{
installedPackages(lib = NULL)
}
\arguments{
\item{lib}{\code{character}.
Destination library directory path.
Defaults to the first element of \code{.libPaths()}.}
}
\description{
Includes \code{"source"} column, indicating whether package is from CRAN,
Bioconductor, or from a remote (i.e. GitHub, GitLab) install.
}
\note{
Updated 2021-08-23.
}
\examples{
x <- installedPackages()
table(x[["source"]])
}
\seealso{
\itemize{
\item \code{sessioninfo::package_info()}.
\item \code{utils::installed.packages()}.
}
}
