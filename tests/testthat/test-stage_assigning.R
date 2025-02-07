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

test_that("Checking final_observed_stage_tabe generation", {

  stage_table = dplyr::tribble(
    ~last_observed_stage, ~n, ~percentage, ~cumulative, ~remaining_n, ~remaining_percentage,
    "Stage1", 1, (1/5)*100, 1, 5, 100,
    "Stage2", 1, (1/5)*100, 2, 4, 80,
    "Stage3", 1, (1/5)*100, 3, 3, 60,
    "Stage4", 1, (1/5)*100, 4, 2, 40,
    "Stage5", 1, (1/5)*100, 5, 1, 20
  )
  stage_table[["last_observed_stage"]] = factor(stage_table[["last_observed_stage"]], levels = example_stages)

  data = stage_assigning(data = example_data, columns = example_stages)
  expect_equal(last_observed_stage_table(data, "last_observed_stage", example_stages), stage_table)

})

data_with_factor = dplyr::tribble(
  ~ID, ~ Stage1, ~Stage2, ~Stage3, ~Stage4, ~Stage5, ~last_observed_stage, ~AB,
  1, "01/01/2000", NA, NA, NA, NA, "Stage1", "A",
  2, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2", "A",
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3", "A",
  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4", "A",
  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5", "A",
  6, NA, NA, NA, NA, NA, "no_stage_found", "A",
  1, "01/01/2000", NA, NA, NA, NA, "Stage1", "B",
  2, "01/01/2000", "02/01/2000", NA, NA, NA, "Stage2", "B",
  3, "01/01/2000", "02/01/2000", "03/01/2000", NA, NA, "Stage3", "B",
  4, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", NA, "Stage4", "B",
  5, "01/01/2000", "02/01/2000", "03/01/2000", "04/01/2000", "05/01/2000", "Stage5", "B",
  6, NA, NA, NA, NA, NA, "no_stage_found", "B"
)
