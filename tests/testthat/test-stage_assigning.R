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

assigned_data = dplyr::tribble(
  ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~last_observed_stage,
  1, "01/01/2000", NA, NA, NA, NA, "Stage1",
  2, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2",
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3",
  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4",
  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5",
  6, NA, NA, NA, NA, NA, "no_stage_found"
)

test_that("stage_assigning() finds the latest stage", {
  expect_equal(stage_assigning(example_stages, example_data), assigned_data)
})
