% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/updatePackages.R
\name{updatePackages}
\alias{updatePackages}
\title{Update all installed packages}
\usage{
updatePackages(lib = .libPaths()[[1L]])
}
\arguments{
\item{lib}{\code{character}.
Destination library directory path.
Defaults to the first element of \code{.libPaths()}.}
}
\value{
\code{logical}.
Validity check return from \code{valid}.
}
\description{
Update all installed packages
}
\note{
Updated 2023-05-17.
}
\examples{
## > updatePackages()
}
