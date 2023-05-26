test_that("multiplication works", {
  expect_equal(
    cbind(outlier_testdata,as.data.frame(tukey_outlier_fun2(outlier_testdata,x))),
    outlier_analysis_testdata)
})
