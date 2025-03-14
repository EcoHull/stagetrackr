% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/time_spanr.R
\name{visualising_time_span}
\alias{visualising_time_span}
\title{Visualising time span distributions}
\usage{
visualising_time_span(
  data,
  cols,
  factor = FALSE,
  stage = stage,
  time_span = time_span
)
}
\arguments{
\item{data}{Data frame containing timespan data columns.}

\item{cols}{A list of the columns containing timespan data such as those produced by time_spanr().}

\item{factor}{(Optional) A factor, variables will be represented as different boxes in the produced graph.}

\item{stage}{Currently predetermined}

\item{time_span}{Currently predetermined}
}
\value{
A box plot of developmental times at each developmental stage, optionally with factors represented by seperate boxes.
}
\description{
Visualising time span distributions
}
\examples{
example_data = dplyr::tribble(
  ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~Sex,
  1, "01/01/2000", NA, NA, NA, NA, "Male",
  2, "01/01/2000", "03/01/2000", NA, NA, NA, "Male",
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Male",
  4, "01/01/2000", "04/01/2000", "05/01/2000", "06/01/2000", NA, "Male",
  5, "01/01/2000", "02/01/2000", "04/01/2000", "07/01/2000", "10/01/2000", "Male",
  6, NA, NA, NA, NA, NA, "Female",
  7, "01/01/2000", NA, NA, NA, NA, "Female",
  8, "01/01/2000", "04/01/2000", NA, NA, NA, "Female",
  9, "01/01/2000", "03/01/2000", "05/01/2000", "09/01/2000", "12/01/2000", "Female",
  10, "01/01/2000", "05/01/2000", "06/01/2000", "07/01/2000", "11/01/2000", "Female"
  )
example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")

time_differences = c("Stage1-Stage2", "Stage2-Stage3", "Stage3-Stage4", "Stage4-Stage5")

formatted_data = time_formatr(example_data, example_stages, "\%d/\%m/\%Y")
time_span_data = time_spanr(formatted_data, example_stages)
visualising_time_span(time_span_data, time_differences, factor = Sex)
}
