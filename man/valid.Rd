% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/valid.R
\name{valid}
\alias{valid}
\title{Validate installed package versions against correct versions}
\usage{
valid()
}
\value{
\code{logical(1)}.
}
\description{
Validate installed package versions against correct versions
}
\note{
Updated 2024-09-04.
}
\section{Library location}{


Calling \code{.libPaths()[[1L]]} internally here. Alternatively, can use
\code{.Library.site} instead. Ensuring we exclude \code{.Library} here, to avoid
unwanted messages about outdated system packages.
}

\examples{
## > valid()
}
