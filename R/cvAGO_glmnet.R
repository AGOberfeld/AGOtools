#' cvAGO.glmnet
#'
#' @param dataset this is the dataset
#' @param X X design matrix for glmnet
#' @param Y Y variable for glmnet
#' @param family distribution family for glm
#' @param standardize specifies if vars are standardized (default = TRUE)
#' @param alpha value of alpha parameter in the elastic net (set to 1 by default = Lasso)
#' @param nfolds number of folds per CV run
#' @param nCVruns number of CV runs
#' @param idVarString variable in dataset identifying the unit of observation in groupdata2's foldid
#' @param type.measure measure used for evaluating the GOF
#' @param ...
#'
#' @return cvfitList= List of cross-validated glmnet models (one per CV run). coefLassodf = dataframe containing the glmnet parameter estimates etc. per CV run
#' @export
#' @import glmnet groupdata2 tidyverse
#' @examples To do
cvAGO.glmnet<-function(dataset,X,Y,family,standardize=TRUE,alpha=1,nfolds,nCVruns,idVarString,type.measure,seedX=4242,...)
{
  #nCVruns: number of CV runs
  #idVarString: grouping (ID) var name (as string) for creating folds, set to NULL if none

  set.seed(seedX)
  cvfitList = list()
  coefLassodfList= list()
  for (ii in 1:nCVruns) {
    kFoldByGroup=NULL
    cvfit=NULL
    coefLassodf.1se=NULL
    coefLassodf.min=NULL

    if (!(is_empty(idVarString))) {
      dfkFoldByGroup <- groupdata2::fold(dataset, k = nfolds, id_col = idVarString)
    } else
    {
      dfkFoldByGroup <- groupdata2::fold(dataset, k = nfolds)
    }
    # dfkFoldByGroup <- dfkFoldByGroup %>% arrange(.folds)  #check folding
    # chkFolds=dfkFoldByGroup %>% select(c("Trial",".folds"))
    # print(table(chkFolds$Trial,chkFolds$.folds))

    kFoldByGroup=as.numeric(dfkFoldByGroup$.folds) # for glmnet

    # Fit Lasso by CV
    # cvfit <- cv.glmnet(x=X, y=Y, family = "binomial", alpha = 1,type.measure = "auc",foldid=kFoldByGroup) #foldid: an optional vector of values between 1 and nfolds identifying what fold each observation is in. If supplied, nfolds can be missing.
    cvfit<-cv.glmnet(x=X,y=Y,family=family,standardize=standardize,nfolds=nfolds,foldid=kFoldByGroup,type.measure=type.measure,alpha=alpha,...)

    # plot(cvfit)                        #AUC for several lambdas
    # coef(cvfit, s = "lambda.min") #Best solution. lambda.min is the value of 𝜆 that gives minimum mean cross-validated error, while lambda.1se is the value of 𝜆 that gives the most regularized model such that the cross-validated error is within one standard error of the minimum.

    coefLassoSparseMatrix.1se=coef(cvfit, s = "lambda.1se") #Best sparse solution
    coefLassodf.1se <- as.data.frame(as.matrix(coefLassoSparseMatrix.1se))
    coefLassodf.1se$predictor <- row.names(coefLassodf.1se)
    coefLassodf.1se=coefLassodf.1se%>%
      rename(
        regCoeffLasso.1se = s1
      )
    coefLassodf.1se=coefLassodf.1se %>% mutate(predSelectedLasso.1se=if_else(regCoeffLasso.1se==0,0,1)) #compute indicator (0/1) specifying if predictor was included in selected model
    #cvm = The mean cross-validated error - a vector of length length(lambda).
    # index: a one column matrix with the indices of lambda.min and lambda.1se in the sequence of coefficients, fits etc.
    coefLassodf.1se=coefLassodf.1se %>% mutate(lambda.1se=cvfit$lambda.1se,AUC.1se_mean=cvfit$cvm[cvfit$index[2]],
                                               AUC.1se_SE=cvfit$cvsd[cvfit$index[2]])

    coefLassoSparseMatrix.min=coef(cvfit, s = "lambda.min") #Best solution
    coefLassodf.min <- as.data.frame(as.matrix(coefLassoSparseMatrix.min))
    coefLassodf.min$predictor <- row.names(coefLassodf.min)
    coefLassodf.min=coefLassodf.min%>%
      rename(
        regCoeffLasso.min = s1
      )
    coefLassodf.min=coefLassodf.min %>% mutate(predSelectedLasso.min=if_else(regCoeffLasso.min==0,0,1))
    coefLassodf.min=coefLassodf.min %>% mutate(lambda.min=cvfit$lambda.min,AUC.min_mean=cvfit$cvm[cvfit$index[1]],
                                               AUC.min_SE=cvfit$cvsd[cvfit$index[1]])

    coefLassodf=full_join(coefLassodf.1se,coefLassodf.min) #join the two solutions
    coefLassodf=coefLassodf%>% mutate(CVrun=ii)
    cvfitList[[ii]]=cvfit #add cvfit to list
    coefLassodfList[[ii]]= coefLassodf #add coeffs to list
  }
  coefLassodf <- bind_rows(coefLassodfList) #combine into one dataframe
  return(list(cvfitList=cvfitList,coefLassodf=coefLassodf))
}
