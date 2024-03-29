% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/devinstall.R
\name{devinstall}
\alias{devinstall}
\title{Install package in development}
\usage{
devinstall(pkg = getwd(), dependencies = FALSE)
}
\arguments{
\item{pkg}{\code{character(1)}.
Package directory path.}

\item{dependencies}{\code{logical(1)}.
Also include dependencies.
Use \code{TRUE} to also install all suggested packages.}
}
\value{
Invisible \code{character(1)}.
Package directory path
}
\description{
Install package in development
}
