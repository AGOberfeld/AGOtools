#' cvGroupRep.glmnet. Runs a by-group repeated cross-validation for glmnet
#'
#' @param dataset this is the dataset (data frame)
#' @param glmFormulaString regression formula compatible with glmnet
#' @param family distribution family for glm
#' @param standardize specifies if vars are standardized (default = TRUE)
#' @param alpha value of alpha parameter in the elastic net (set to 1 by default = Lasso)
#' @param nfolds number of folds per CV run (default = 10)
#' @param nCVruns number of CV runs (default = 1)
#' @param idVarString variable in dataset identifying the unit of observation in groupdata2's foldid. Must be numeric (default = NULL; no grouping variable)
#' @param type.measure measure (loss function) used for evaluating the GOF
#' @param seedX seed for random number generator, default = 4444
#' @param ... optional  parameters passed to cv.glmnet()
#'
#' @return cvfitList= List of cross-validated glmnet models (one per CV run). coefLassodf = dataframe containing the glmnet parameter estimates etc. per CV run
#' @export
#' @import glmnet groupdata2 dplyr

cvGroupRep.glmnet<-function(dataset,glmFormulaString,family,standardize=TRUE,alpha=1,nfolds=10,nCVruns=1,
                            idVarString=NULL,type.measure,seedX=4444,...)
{
  #define design matrix, without intercept term (column 1)
  X <- model.matrix(as.formula(glmFormulaString), data=dataset)[,-1]
  #and the outcome variable: extract DVstring from glmFormula
  formulaTerms=terms(as.formula(glmFormulaString))
  formulaVars=attr(formulaTerms, which = "variables")
  DVstring=as.character(formulaVars[[attr(formulaTerms,which="response")+1]])
  Y <- as.matrix(dataset[,DVstring])

  set.seed(seedX)
  cvfitList = list()
  coefLassodfList= list()
  for (ii in 1:nCVruns) {
    dfkFoldByGroup=NULL
    kFoldByGroup=NULL
    cvfit=NULL
    coefLassoSparseMatrix.1se=NULL
    coefLassodf.1se=NULL
    coefLassoSparseMatrix.min=NULL
    coefLassodf.min=NULL
    coefLassodf=NULL

    if (!(is_empty(idVarString))) {
      #CV-by-group
      cat('cvGroupRep.glmnet:: CV-by-group: ',idVarString,'\n')
      dfkFoldByGroup <- groupdata2::fold(dataset, k = nfolds, id_col = idVarString)
    } else
    {
      #random CV
      cat('cvGroupRep.glmnet:: random CV\n')
      dfkFoldByGroup <- groupdata2::fold(dataset, k = nfolds)
    }
    # dfkFoldByGroup <- dfkFoldByGroup %>% arrange(.folds)  #check folding
    # chkFolds=dfkFoldByGroup %>% select(c("Trial",".folds"))
    # print(table(chkFolds$Trial,chkFolds$.folds))

    kFoldByGroup=as.numeric(dfkFoldByGroup$.folds) # for glmnet

    # Fit Lasso by CV
    cvfit<-cv.glmnet(x=X,y=Y,family=family,standardize=standardize,nfolds=nfolds,
                     foldid=kFoldByGroup,type.measure=type.measure,alpha=alpha,...) #foldid: an optional vector of values between 1 and nfolds identifying what fold each observation is in. If supplied, nfolds can be missing.

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
    coefLassodf.1se=coefLassodf.1se %>% mutate(lambda.1se=cvfit$lambda.1se,lossM.1se_mean=cvfit$cvm[cvfit$index[2]],
                                               lossM.1se_SE=cvfit$cvsd[cvfit$index[2]])

    coefLassoSparseMatrix.min=coef(cvfit, s = "lambda.min") #Best solution
    coefLassodf.min <- as.data.frame(as.matrix(coefLassoSparseMatrix.min))
    coefLassodf.min$predictor <- row.names(coefLassodf.min)
    coefLassodf.min=coefLassodf.min%>%
      rename(
        regCoeffLasso.min = s1
      )
    coefLassodf.min=coefLassodf.min %>% mutate(predSelectedLasso.min=if_else(regCoeffLasso.min==0,0,1))
    coefLassodf.min=coefLassodf.min %>% mutate(lambda.min=cvfit$lambda.min,lossM.min_mean=cvfit$cvm[cvfit$index[1]],
                                               lossM.min_SE=cvfit$cvsd[cvfit$index[1]])

    coefLassodf=full_join(coefLassodf.1se,coefLassodf.min,by = join_by(predictor)) #join the two solutions
    coefLassodf=coefLassodf%>% mutate(CVrun=ii,type.measure=type.measure)
    cvfitList[[ii]]=cvfit #add cvfit to list
    coefLassodfList[[ii]]= coefLassodf #add coeffs to list
  }
  coefLassodf <- bind_rows(coefLassodfList) #combine into one dataframe
  return(list(cvfitList=cvfitList,coefLassodf=coefLassodf))
}
