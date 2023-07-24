test_that("tukey_outlier_fun works", {
  expect_equal(
    outlier_analysis_testdata_groupwise %>%
      ungroup() %>%
      mutate(as_tibble(tukey_outlier_fun(x))),
    outlier_analysis_testdata_groupwise_results_overall)
})
