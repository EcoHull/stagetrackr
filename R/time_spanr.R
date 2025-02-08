time_formatr = function (data, stages, format) {
  date_data = data |>
    dplyr::mutate(dplyr::across(dplyr::all_of(stages), ~as.Date(., format)))
  return(date_data)
}

time_spanr = function(data, stages) {
  for (i in seq_along(stages)[-length(stages)]) {
    name = paste0("time_",stages[i], "_to_", stages[i+1])
    time_difference = data[[stages[i + 1]]] - data[[stages[i]]]
    data[name] = time_difference
  }
  return(data)
}
