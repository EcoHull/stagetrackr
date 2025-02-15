#' Converts the type of columns to dates
#'
#' @param data The data frame containing the data.
#' @param stages The columns containing the stage data.
#' @param format  The format of the dates in the data frame.
#'
#' @returns A dataframe with foramtted dates.
#' @export
#'
#' @examples
#' example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")
#' example_data = dplyr::tribble(
#'   ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5,
#'   1, "01/01/2000", NA, NA, NA, NA,
#'   2, "01/01/2000", "02/01/2000", NA, NA, NA,
#'   3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA,
#'   4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA,
#'   5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000",
#'   6, NA, NA, NA, NA, NA,
#' )
#' time_formatr(example_data, example_stages, "%d/%m/%Y")
time_formatr = function (data, stages, format) {
  date_data = data |>
    dplyr::mutate(dplyr::across(dplyr::all_of(stages), ~as.Date(., format)))
  return(date_data)
}

#' Generated time span data between developmental stages
#'
#' @param data Data frame containing the data.
#' @param stages List of stages containing rows of formatted dates.
#'
#' @returns Columns of time differences between sequential stages
#' @export
#'
#' @examples
#' example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")
#' example_data = dplyr::tribble(
#'   ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5,
#'   1, "01/01/2000", NA, NA, NA, NA,
#'   2, "01/01/2000", "02/01/2000", NA, NA, NA,
#'   3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA,
#'   4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA,
#'   5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000",
#'   6, NA, NA, NA, NA, NA,
#' )
#' formatted_data = time_formatr(example_data, example_stages, "%d/%m/%Y")
#' time_spanr(formatted_data, example_stages)
time_spanr = function(data, stages) {
  for (i in seq_along(stages)[-length(stages)]) {
    name = paste0(stages[i], "-", stages[i+1])
    time_difference = data[[stages[i + 1]]] - data[[stages[i]]]
    data[name] = time_difference
  }
  return(data)
}

#' Visualising time span distributions
#'
#' @param data Data frame containing timespan data columns.
#' @param cols A list of the columns containing timespan data.
#' @param factor (Optional) A factor, variables will be represented as different boxes in the produced graph.
#' @param stage Currently predetermined
#' @param time_span Currently predetermined
#'
#' @returns A box plot of developmental times at each developmental stage, optionally with factors represented by seperate boxes.
#' @export
#'
#' @examples
#' example_data = dplyr::tribble(
#'   ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~Sex,
#'   1, "01/01/2000", NA, NA, NA, NA, "Male",
#'   2, "01/01/2000", "03/01/2000", NA, NA, NA, "Male",
#'   3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Male",
#'   4, "01/01/2000", "04/01/2000", "05/01/2000", "06/01/2000", NA, "Male",
#'   5, "01/01/2000", "02/01/2000", "04/01/2000", "07/01/2000", "10/01/2000", "Male",
#'   6, NA, NA, NA, NA, NA, "Female",
#'   7, "01/01/2000", NA, NA, NA, NA, "Female",
#'   8, "01/01/2000", "04/01/2000", NA, NA, NA, "Female",
#'   9, "01/01/2000", "03/01/2000", "05/01/2000", "09/01/2000", "12/01/2000", "Female",
#'   10, "01/01/2000", "05/01/2000", "06/01/2000", "07/01/2000", "11/01/2000", "Female"
#'   )
#' example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")
#'
#' time_differences = c("Stage1-Stage2", "Stage2-Stage3", "Stage3-Stage4", "Stage4-Stage5")
#'
#' formatted_data = time_formatr(example_data, example_stages, "%d/%m/%Y")
#' time_span_data = time_spanr(formatted_data, example_stages)
#' visualising_time_span(time_span_data, time_differences, factor = Sex)
visualising_time_span = function(data, cols, factor = FALSE, stage = stage, time_span = time_span) {

  factor_status = deparse(substitute(factor))

  data = tidyr::pivot_longer(data, cols = cols, names_to = "stage", values_to = "time_span")

  plot = ggplot2::ggplot(data, ggplot2::aes(x = {{stage}}, y = {{time_span}})) +
    ggplot2::geom_boxplot(ggplot2::aes(fill = {{factor}})) +
    ggplot2::labs(y = "Time Span", x = "Developmental Stage") +
    ggplot2::theme_classic()


  if (factor_status == "FALSE") {
    plot = plot +
      ggplot2::theme(legend.position = "none") +
      ggplot2::scale_fill_manual(values = "grey")
  }
  plot
}
