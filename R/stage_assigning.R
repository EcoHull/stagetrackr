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
