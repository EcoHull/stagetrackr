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

test_that("Columns specified are converted to data", {

  formatted_data = time_formatr(example_data, example_stages, "%d/%m/%Y")

  expect_s3_class(formatted_data$Stage1, "Date")
  expect_s3_class(formatted_data$Stage3, "Date")
  # expect_s3_class(formatted_data$Stage5, "Date")

  expect_type(formatted_data$ID, "double")

})

