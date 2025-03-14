#' Finds the latest recorded developmental stage
#'
#' @param columns A character vector specifying the column names of each stage in order.
#' @param data The data frame containing information of date an individual reached a specific developmental stage with one row for each individual.
#'
#' @returns A new column "last_observed_stage" which contains the last stage found.
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
      last_observed_stage = (apply(data[columns], 1, function(x) {
        last_non_na <- utils::tail(x[!is.na(x)], 1)
        if (length(last_non_na) > 0) {
          names(last_non_na)
        } else {
          "no_stage_found"
        }
      })) |> factor(levels = columns)
    )
}

#' Generated data table for observed stages
#'
#' @param data A data frame containing a column with the last observed stages of each row, such as those generated by stage_assigning()
#' @param last_observed_stage The name of the column specifying the last observed stage within each row.
#' @param factor (Optional) Specify a factor, this will generate variable specific tables
#'
#' @returns A data table containing information about the distribution of individuals across stages, including the number and percentage of individuals for which it was the final developmental stage and the number and percentage of individuals remaining at each stage.
#' @export
#'
#' @examples
#' example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")
#' assigned_data = dplyr::tribble(
#'   ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~last_observed_stage,
#'   1, "01/01/2000", NA, NA, NA, NA, "Stage1",
#'   2, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2",
#'   3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3",
#'   4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4",
#'   5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5",
#'   6, NA, NA, NA, NA, NA, "no_stage_found"
#' )
#' last_stage_table(assigned_data, "last_observed_stage")
last_stage_table = function(data, last_observed_stage, factor = NULL) {
  data = subset(data, last_observed_stage != "no_stage_found")

  if (!is.null(factor)) {
    print("there is a factor")
    data |>
      dplyr::group_by(dplyr::across({{factor}})) |>
      dplyr::do(
      stage_data(.data, last_observed_stage = "last_observed_stage")
      )
  } else {
    stage_data(data, "last_observed_stage")
  }
}

stage_data = function(data, last_observed_stage) {
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

#' Generates a bar graph containing information about progression through each developmental stage
#'
#' @param data Data frame containing information about survival at each stage, such as those generated by last_observed_stage_table()
#' @param stages Column specifying the name of each stage
#' @param remaining_percentage Column specifying the percentage remaining at each developmental stage
#' @param remaining_number Column representing the number of individuals remaining at each stage (optional)
#' @param factor (Optional) Factor to seperate the columns based on
#' @param dp Number of decimal points to display the percentage until
#'
#' @returns ggplot bar graph with information about percentage survival (and N numbers if provided) at each stage.
#' @export
#'
#' @examples
#' stage_table = dplyr::tribble(
#'   ~last_observed_stage, ~n, ~percentage, ~cumulative, ~remaining_n, ~remaining_percentage,
#'   "Stage1", 1, (1/5)*100, 1, 5, 100,
#'   "Stage2", 1, (1/5)*100, 2, 4, 80,
#'   "Stage3", 1, (1/5)*100, 3, 3, 60,
#'   "Stage4", 1, (1/5)*100, 4, 2, 40,
#'   "Stage5", 1, (1/5)*100, 5, 1, 20
#' )
#'
#' visualising_survival(stage_table, last_observed_stage, remaining_percentage, remaining_n)
#' visualising_survival(stage_table, last_observed_stage, remaining_percentage)
#'
#' factor_table = dplyr::tribble(
#'   ~last_observed_stage, ~n, ~percentage, ~cumulative, ~remaining_n, ~remaining_per, ~sex,
#'   "Stage1", 1, (1/5)*100, 1, 5, 100, "M",
#'   "Stage2", 1, (1/5)*100, 2, 4, 80, "M",
#'   "Stage3", 1, (1/5)*100, 3, 3, 60, "M",
#'   "Stage4", 1, (1/5)*100, 4, 2, 40, "M",
#'   "Stage5", 1, (1/5)*100, 5, 1, 20, "M",
#'   "Stage1", 1, (1/5)*100, 1, 5, 100, "F",
#'   "Stage2", 1, (1/5)*100, 2, 4, 80, "F",
#'   "Stage3", 1, (1/5)*100, 2, 4, 80, "F",
#'   "Stage4", 1, (1/5)*100, 3, 3, 60, "F",
#'   "Stage5", 1, (1/5)*100, 5, 1, 20, "F"
#' )
#'
#' visualising_survival(factor_table, last_observed_stage, remaining_per, remaining_n, factor = sex)
visualising_survival = function(data, stages, remaining_percentage, remaining_number = NULL, factor = FALSE, dp = 2) {
  remaining_per <- deparse(substitute(remaining_percentage))
  remaining_num <- deparse(substitute(remaining_number))
  factor_status = deparse(substitute(factor))

  if (factor_status == "FALSE") {
    label_position = ggplot2::position_identity()
  } else {
    label_position = ggplot2::position_dodge2(width = 0.9, preserve = "single")
  }

  plot = ggplot2::ggplot(data, ggplot2::aes(x = {{stages}}, y = {{remaining_percentage}}, fill = {{factor}})) +
      ggplot2::geom_col(colour = "black", position = "dodge") +
      ggplot2::geom_text(ggplot2::aes(label = paste0(round(.data[[remaining_per]], dp), "%")), position = label_position, # Access with []
                         y = 0, vjust = -0.5) +
      ggplot2::labs(x = "Remaining percentage", y = "Last observed stage") +
      ggplot2::theme_classic()

  if (remaining_num != "NULL") {
    plot = plot + ggplot2::geom_text(ggplot2::aes(label = paste0("( N = ", .data[[remaining_num]], ")")), position = label_position,
      y = 0, vjust = -2.5)
  }

  if (factor_status == "FALSE") {
    plot = plot +
      ggplot2::theme(legend.position = "none") +
      ggplot2::scale_fill_manual(values = "grey")
  }

  return(plot)
}

#' Final observed stage distribution graph generation
#'
#' @param data Data frame containing a column with the last observed stage such as those produced by stage_assigning()
#' @param stage The name of the column containing the final observed stage
#' @param factor (Optional) Set factor variables, each unique variable will generate a separate bar
#'
#' @returns ggplot stacked bar graph showing the distributions of the final observed stage
#' @export
#'
#' @examples
#' assigned_data = dplyr::tribble(
#'   ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~last_observed_stage,
#'   1, "01/01/2000", NA, NA, NA, NA, "Stage1",
#'   2, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2",
#'   3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3",
#'   4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4",
#'   5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5",
#'   6, NA, NA, NA, NA, NA, "no_stage_found"
#' )
#' visualising_distribution(assigned_data, last_observed_stage)
#'
#' data_with_factor = dplyr::tribble(
#'  ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~last_observed_stage, ~AB,
#'  1, "01/01/2000", NA, NA, NA, NA, "Stage1", "A",
#'  2, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2", "A",
#'  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3", "A",
#'  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4", "A",
#'  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5", "A",
#'  6, NA, NA, NA, NA, NA, "no_stage_found", "A",
#'  7, "01/01/2000", NA, NA, NA, NA, "Stage1", "B",
#'  8, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2", "B",
#'  9, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3", "B",
#'  10, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4", "B",
#'  11, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5", "B",
#'  12, NA, NA, NA, NA, NA, "no_stage_found", "B"
#' )
#' visualising_distribution(data_with_factor, last_observed_stage, AB)
visualising_distribution = function(data, stage, factor = FALSE) {

  fct = deparse(substitute(factor))

  plot = ggplot2::ggplot(data, ggplot2::aes(x = {{factor}}, group = {{stage}})) +
    ggplot2::labs(y = "Proportion", fill = deparse(substitute(stage)), x = deparse(substitute(factor))) +
    ggplot2::geom_bar(ggplot2::aes(fill = {{stage}}), position = "fill", colour = "black") +
    ggplot2::theme_classic()

  if (fct == "FALSE") {
    plot = plot +
      scale_x_discrete(labels = "") +
      ggplot2::labs(x = "Distribution of last observed stages")
  }
  plot
}
