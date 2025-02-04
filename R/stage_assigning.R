#' Finds the latest recorded developmental stage
#'
#' @param columns A character vector specifying the column names of each stage in order.
#' @param data The data frame containing information of date an individual reached a specific developmental stage with one row for each individual.
#'
#' @returns A new column "last_observed_stage" which contains the last stage found with a date in it.
#' @export
#'
#' @examples
#' example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")
#' example_data = dplyr::tribble(
#' ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5,
#'   1, "01/01/2000", NA, NA, NA, NA,
#'   2, "01/01/2000", "02/01/2000", NA, NA, NA,
#'   3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA,
#'   4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA,
#'   5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000",
#'   6, NA, NA, NA, NA, NA,
#' )
#' stage_assigning(columns = example_stages, data = example_data)
stage_assigning <- function(columns, data) {
  data |>
    dplyr::mutate(
      last_observed_stage = apply(data[columns], 1, function(x) {
        last_non_na <- utils::tail(x[!is.na(x)], 1)
        if (length(last_non_na) > 0) {
          names(last_non_na)
        } else {
          "no_stage_found"
        }
      })
    )
}

last_observed_stage_table = function(data, last_observed_stage) {
  data = subset(data, last_observed_stage != "no_stage_found")

  n_total = nrow(data)

  table = data |>
    dplyr::group_by(last_observed_stage) |>
    dplyr::count(name = "n") |>
    dplyr::as_tibble()

  table$percentage = (table[["n"]]/n_total)*100
  table$cumulative = cumsum(table[["n"]])
  table$remaining_n = n_total - table[["cumulative"]] + table[["n"]]
  table$remaining_percentage = (table[["remaining_n"]] / n_total) * 100

  return(table)
}

visualising_survival = function(data, stages, remaining_percentage, remaining_number) {
  remaining_per <- deparse(substitute(remaining_percentage))
  remaining_num <- deparse(substitute(remaining_number))

  ggplot2::ggplot(data, ggplot2::aes(x = {{stages}}, y = {{remaining_percentage}})) +
    ggplot2::geom_col(colour = "black", fill = "lightgrey") +
    ggplot2::geom_text(ggplot2::aes(label = paste0(.data[[remaining_per]], "%")), # Access with []
                       y = 0, vjust = -0.5) +
    ggplot2::geom_text(ggplot2::aes(label = ifelse(is.null({{remaining_number}}), "", paste0("( N = ",.data[[remaining_num]], ")"))), # Access with []
                       y = 0, vjust = -2.5) +
    ggplot2::theme_classic()

}

visualising_distrubution = function(data, stage, factor = 1) {
  ggplot2::ggplot(data, ggplot2::aes(x = {{factor}}, group = {{stage}})) +
    ggplot2::labs(y = "Proportion", fill = deparse(substitute(stage)), x = deparse(substitute(factor))) +
    ggplot2::geom_bar(ggplot2::aes(fill = {{stage}}), position = "fill", colour = "black") +
    ggplot2::theme_classic()
}

