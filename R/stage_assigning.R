example_stages = c("Stage1", "Stage2", "Stage3", "Stage4", "Stage5")

example_data = dplyr::tribble(
  ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5,
  1, "01/01/2000", NA, NA, NA, NA,
  2, "01/01/2000", "02/01/2000", NA, NA, NA,
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA,
  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA,
  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000",
  6, NA, NA, NA, NA, NA,
)


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
