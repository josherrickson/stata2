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
