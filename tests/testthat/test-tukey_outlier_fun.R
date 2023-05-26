test_that("multiplication works", {
  expect_equal(
    outlier_testdata %>%
                 mutate(as_tibble(tukey_outlier_fun(x))),
    outlier_analysis_testdata)
})
