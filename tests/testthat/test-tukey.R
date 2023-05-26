test_that("multiplication works", {
  expect_equal(
    tukey(outlier_testdata,x),
    outlier_analysis_testdata)
})
