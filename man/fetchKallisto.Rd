% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetchKallisto.R
\name{fetchKallisto}
\alias{fetchKallisto}
\title{fetch one sample's worth of Kallisto estimates, perhaps with bootstraps}
\usage{
fetchKallisto(sampleDir = ".", h5file = "abundance.h5",
  collapse = "_mergedWith_", ...)
}
\arguments{
\item{sampleDir}{character string: the path to h5/json files}

\item{h5file}{character string: the file to read}

\item{collapse}{string: collapsing string for indices ("_mergedWith_")}
}
\description{
fetch one sample's worth of Kallisto estimates, perhaps with bootstraps
}

