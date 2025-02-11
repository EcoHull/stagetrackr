time_formatr = function (data, stages, format) {
  date_data = data |>
    dplyr::mutate(dplyr::across(dplyr::all_of(stages), ~as.Date(., format)))
  return(date_data)
}

time_spanr = function(data, stages) {
  for (i in seq_along(stages)[-length(stages)]) {
    name = paste0(stages[i], "-", stages[i+1])
    time_difference = data[[stages[i + 1]]] - data[[stages[i]]]
    data[name] = time_difference
  }
  return(data)
}

spanr_visualiation = function(data, cols, factor = FALSE, stage = stage, time_span = time_span) {

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
