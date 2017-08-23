^#^ Regression

One notable exclusion from the previous session was comparing the mean of a continuous variables across three or more groups. Two-sample t-tests
compare the means across two groups, and ^$^\chi^2^$^ tests can compare two categorical variables with arbitrary number of levels, but the traditional
test for comparing means across multiple groups is ANOVA (ANalysis Of VAriance). While historically this has been a very useful procedure due to the
ease with which it can be performed manually, its modern use has been supplanted by regression, which is mathematically equivalent and easier to
extend (the downside of regression is that it is more difficult to calculate, but given that we are no longer doing statistical analyses by
hand....). This relationship extends to other variations of ANOVA such as ANCOVA or MANOVA.

If you still want to fit an ANOVA, it can be done with the `oneway` command. Otherwise we turn now to regression.

Regression is a set of techniques where we attempt to fit a model to a data set estimating the relationships between a set of predictor variables
(either continuous or categorical in nature) and a response variable of interest. There are many versions of regression which are appropriate for
different types of response variables, or address different concerns when fitting the model. In this chapter and the next, we will discuss a few
variations.

^#^^#^ Terminology

When discussing any form of regression, we think of predicting the value of one variable^[There are variations of regression with multiple outcomes,
but they are for very specialized circumstances and can generally be fit as several basic regression models instead] based upon several other
variables.

The variable we are predicting can be called the "outcome", the "response" or the "dependent variable".

The variables upon which we are predicting can be called "predictors", "covariates", or "independent variables".

^#^^#^ Linear Regression

Linear regresison (also known as Ordinary Least Squares (OLS) regression) is the most basic form of regression, where the response variable is
continuous. Technically the response variable can also be binary or categorical but there are better regression models for those types of
outcomes. Linear regression fits this model:

^$$^
  Y = \beta_0 + \beta_1X_1 + \beta_2X_2 + \cdots + \beta_pX_p + \epsilon
^$$^

- ^$^Y^$^ represents the outcome variable.
- ^$^X_1, X_2, \cdots, X_p^$^ represent the predictors, of which there are ^$^p^$^ total.
- ^$^\beta_0^$^ represents the intercept. If you have a subject for which every predictor is equal to zero, ^$^\beta_0^$^ represents their predicted
  outcome.
- The other ^$^\beta^$^'s are called the coefficients, and represent the relationship between each predictor and the response. We will cover their
  interpretation in detail later.
- ^$^\epsilon^$^ represents the error. Regression is a game of averages, but for any individual observation, the model will contain some error.

Linear regression models can be used to predict expected values on the response variable given values on the predictors, and ^$^\epsilon^$^
represents the difference between a prediction based on the model and what the actual value of the response variable is. Stata can be used to estimate
the regression coefficients in a model like the one above, and perform statistical tests of the null hypothesis that the coefficients are equal to
zero (and thus that predictor variables are not important in explaining the response). Note that the response ^$^Y^$^ is modeled as a linear
combination of the predictors and their coefficients.

Some introductory statistical classes distinguish between simple regression (with only a single predictor) and multiple regression (with more than one
predictor). While this is useful for developing the theory of regression, simple regression is not commonly used for real analysis, as it ignores one
of the main benefits of regression, controlling for other predictors (to be discussed later).

We will now fit a model, discussing assumptions afterwards, because almost all assumption checks can only occur once the model is fit!

^#^^#^^#^ Fitting the model

Stata's `regress` command fit the linear regression model. It is followed by the outcome variable followed by all predictors. For this example, let's
reload the auto data and fit a relatively simple model, predicting `mpg` based on `weight` and `displacement`.

~~~~
<<dd_do>>
regress mpg weight displacement
<</dd_do>>
~~~~

There is a lot of important output here, so we will step through each piece.

First, the top left table is the ANOVA table. If you were to fit a regression model with a
single [categorical predictor](#continuous-vs-categorical-predictors), this would be identical to running ANOVA via `oneway`. In general we don't need
to interpret anything here, as there are further measures of model fit in the regression frameworks.

Next, the top right part has a series of measures.

- Regression performs complete case analysis - any observations missing any variable involved in this model is ignored in the
  model. (See [multiple imputation](multiple-imputation.html) for details on getting around this.) Check "Number of obs" to ensure the number of
  observations is what you expect. Here, the data has 74 rows, so the regression model is using all the data (there is no missinginess in `mpg`,
  `weight` or `displacement`).
- The F-test which follows ("F(2, 71)"^[The 2 and 71 are degrees of freedom. They don't typically add any interpretation.] and "Prob > F") is testing
  the null hypothesis that all coefficients are 0. In other words, if this test fails to reject, the conclusion is the model captures no
  relationships. In this case, do not continue interpreting the results; either your conclusion is that there is no relationship, or you need to
  return to the model design phase. If this test does reject, you can continue interpretating.
- The ^$^R^2^$^ ("R-squared") is a measure of model fit. It ranges from 0 to 1 and is a percentage, explaining what percent in the variation in the
  response is explained by the linear relationship with the predictors. What's considered a "large" ^$^R^2^$^ depends greatly on your field and the
  situation, in very general terms, .6 is good and above .8 is great. However, if you know that there are a lot of unmeasured variables, a much
  smaller ^$^R^2$^$ can be considered good as well.
- Mathematically, adding a new predictor to the model will increase the $^$R^2$^$, regardless of how useless the variable is.^[The only exception is
  if the predictor being added is either constant or identical to another variable.] This makes ^$^R^2^$^$ poor for model comparison, as it would
  always select the model with the most predictors. Instead, the adjusted $^$R^2$^$ ("Adj R-Squared") accounts for this; it penalizes the $^$R^2$^$ by
  the number of predictors in the model. Use the $^$R^2$^$ to measure model fit, use the adjusted $^$R^2$^$ for model comparison.
- The root mean squared error ("Root MSE", as known as RMSE) is a measure of the average difference between the observed outcome and the predicted
  outcome. It can be used as another measure of model fit, as it is on the scale of the outcome variable. So for this example, the RMSE is abour 3.5,
  so the average error in the model is about 3.5 mpg.

Finally, we get to the coefficient table.

- F-test
- R2, Adj R2
- RMSE
- Coefficient table

- Include rep78 to show i. c.
- Include interaction to show ##

Then

Assumptions:
- Independence
- Residuals have constant variance and are normal.
- Relationship is linear & additive.

- Confounding
- Overfitting 1:10 or 1:20
- Why model selection is bad


^#^^#^ Logistic

^#^^#^ Poisson Maybe
