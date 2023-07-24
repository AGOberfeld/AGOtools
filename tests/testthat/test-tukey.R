test_that("tukey overall works", {
  expect_equal(
    tukey(outlier_analysis_testdata_groupwise,x),
    outlier_analysis_testdata_groupwise_results_overall)
})

test_that("tukey groupwise works", {
  expect_equal(
    outlier_analysis_testdata_groupwise %>%
      group_by(group) %>%
      tukey(x) ,
    outlier_analysis_testdata_groupwise_results_groups)
})
