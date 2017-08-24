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
  smaller ^$^R^2^$^ can be considered good as well.
- Mathematically, adding a new predictor to the model will increase the ^$^R^2^$^, regardless of how useless the variable is.^[The only exception is
  if the predictor being added is either constant or identical to another variable.] This makes ^$^R^2^$^$ poor for model comparison, as it would
  always select the model with the most predictors. Instead, the adjusted ^$^R^2^$^ ("Adj R-Squared") accounts for this; it penalizes the ^$^R^2^$^ by
  the number of predictors in the model. Use the ^$^R^2^$^ to measure model fit, use the adjusted ^$^R^2^$^ for model comparison.
- The root mean squared error ("Root MSE", as known as RMSE) is a measure of the average difference between the observed outcome and the predicted
  outcome. It can be used as another measure of model fit, as it is on the scale of the outcome variable. So for this example, the RMSE is
  <<dd_display: %9.4f e(rmse)>> so the average error in the model is about 3.5 mpg.

Finally, we get to the coefficient table. Each row represents a single predictor. The "\_cons" row is the intercept; it's first entry
<<dd_display: %9.4f _b[_cons]>> represents the average response *when all other predictors are 0*. This is usually not interesting; how many cars
weighing 0 lbs do you know of? So we'll ignore this and instead go over the other rows.

- "Coef.": These are the ^$^\beta^$^ from the above model. We interpret each as "For a 1 increase in the value of the covariate with all other
  predictors held constant, we would predict this change in the response, on average." For example, for every additional lb^[This is why it's
  important to familiarize yourself with the units in your data!] a car weighs (while its displacement is constant), it is predicted to have an
  average of <<dd_display: %9.4f _b[weight]>> lower mpg.
- "Std. Err.": This represents the error attached to the coefficient. This is rarely interpreted; but if it gets extremely large or extremely small
  (and the Coef. doesn't likewise go to extremes), its an indication there may be something wrong.
- "t": This is the standardized coefficient, calculated as Coef./Std. Err. We can't directly compare the Coef.'s because of the different scales, but
  we can examine the standardized coefficients to get a sense of which predictor has a larger impact. In this model, we see that the impact of weight
  is much more than the impact of displacement.
- "P>|t|": The p-value testing whether the coefficient is significantly different than 0. In this model, we see that `weight` has a significant
  p-value, while `displacement` does not.
- "[95% Conf. interval]": A range of possible values.

Whenever we look at any model, a distinction needs to be drawn between statistical significance and practical significance. While these two
interpretations of significance often align, they are not guaranteed to. We often have statistical significance (a p-value less than .05) when there
is no practical significance (aka clinical significance, a difference that isn't scientifically interesting). This is mostly a function of sample
size; with a large sample even very small effects can have small p-values. Alternatively, a large practical significance with a low statistical
significance can occur with very noisy data or a small sample size, which might indicate further study with a larger sample is needed.

^#^^#^^#^ Including categorical predictors

Let's say we want to add `rep78`, a categorical variable with 5 levels, to the model. Naively, we simply add it:

~~~~
<<dd_do>>
regress mpg weight displacement rep78
<</dd_do>>
~~~~

We only get a single coefficient. Stata is treating `rep78` as continuous. When including a categorical predictor, Stata will create dummy variables
(variables which take on value 1 if the observation is in that category and 0 otherwise) and include all but one, which is the refernce (or
baseline). Since we only see a single coefficient here, we know Stata did it incorrectly.

The issue is that Stata doesn't know we want to treat `rep78` as categorical. If we prefix the variable name with `i.`, Stata will know it is
categorical.

~~~~
<<dd_do>>
regress mpg weight displacement i.rep78
<</dd_do>>
~~~~

Now we see 4 rows for `rep78`, each corresponding to a comparison between response 1 and the row. For example, the first row, 2, is saying that when
`rep78` is 2 compare to when it is 1, the average predicted response drops by <<dd_display: %9.3f abs(_b[2.rep78])>> (though it is not statistical
signifcant). The last row, 5, is saying that when `rep78` is 5 compare to when it is 1, the average predicted response increases by <<dd_display:
%9.3f _b[5.rep78]>> (again, not statistically significant).

To see the other comparisons (does 2 differ from 4?), we can use the `margins` command.

~~~~
<<dd_do>>
margins rep78
margins rep78, pwcompare(pv)
<</dd_do>>
~~~~

The first `margins` call, without any options, displays the marginal means for each category - with all other variable (`weight` and `displacement`)
at their mean, it's the average predicted mileage of all cars whose `rep78` value is at each level. The t-test here is useless - it's only testing
that the average mileage of the cars in each group is not 0!

The second `margins` call adds the `pwcompare(pv)` option, which performs pairwise test between each pair of `rep78` levels. This is similar to a
post-hoc test from ANOVA if you are familiar with it. The only statistical significance we find is 5 vs 3 and 5 vs 4 (both marginally significant),
suggesting very weak evidence that 5 is different from 3 and 4, and further study may be required.

By default, using `i.` makes the first level (lowest numerical value) as the reference category. You can adjust this by using `ib#.` instead, such as:

~~~~
<<dd_do>>
regress mpg weight displacement ib3.rep78
<</dd_do>>
~~~~

^#^^#^^#^ Interactions

Each coefficient we've look at so far is only testing whether there is a relationship between the predictor and response when the other predictors are
held constant. What if we think the relationship changes based on the value of other predictors? For example, we might be interested in whether the
relationship between a car's weight and its mileage depends on it's repair record. Perhaps we think that poorly made cars may not see as much a
benefit from lowering the weight. We can test this by including an interaction.

Mathematically an interaction is nothing more than a literal multiplication. For example, if our model has only two predictors,

^$$^
  Y = \beta_0 + \beta_1X_1 + \beta_2X_2 + \epsilon
^$$^

then to add an interaction between ^$^X_1^$^ and ^$^X_2^$^, we simply add a new multiplicative term.

^$$^
  Y = \beta_0 + \beta_1X_1 + \beta_2X_2 + \beta_3(X_1\times X_2) + \epsilon
^$$^

- ^$^\beta_1\^$^ represents the relationship between ^$^X_1^$^ and ^$^Y^$^ when ^$^X_2^$^ is identically equal to 0.
- ^$^\beta_2\^$^ represents the relationship between ^$^X_2^$^ and ^$^Y^$^ when ^$^X_1^$^ is identically equal to 0.
- ^$^\beta_3\^$^ represents **both**:
    - the change in the relationship between ^$^X_1^$^ and ^$^Y^$^ as ^$^X_2^$^ changes.
    - the change in the relationship between ^$^X_2^$^ and ^$^Y^$^ as ^$^X_1^$^ changes.

Adding these to the `reg` call is almost as easy. We'll use `#` or `##` instead. `#` includes only the interaction, whereas `##` includes both the
interaction and the main effects.

- `a#b`: Only the interaction
- `a##b`: Main effect for `a`, main effect for `b`, and the interaction.
- `a b a#b`: Same as `a##b`
- `a b a##b`: Same as `a##b`, except it'll be uglier because you're including main effects twice and one will be ignored.

~~~~
<<dd_do>>
regress mpg c.weight##c.displacement i.rep78
<</dd_do>>
~~~~

Note that we used `c.`, similar to `i.`. `c.` forces Stata to treat it as continuous. Stata assumes anything in an interaction is categorical, so we
need `c.` here! This can get pretty confusing, but it's never wrong to include `i.` or `c.` when specifying a regression.

Once we include an interaction, the relationship between the variables included in the interaction and the response are not constant - the
relationship depends on the value of the other interacted variables. This can be hard to visualize with the basic regression output, so we'll look at
`margins` again instead.

First, we can look at the relationship between vehicle weight and mileage when displacement is at its average. (We're ignoring `rep78` here because it
does not take place in the interaction, so all interpretations should add "... with `rep78` held constant.")

~~~~
<<dd_do>>
margins, dydx(weight)
<</dd_do>>
~~~~

Since `weight` is continuous (unlike `rep78` which was entered into the model as `i.rep78` [previously](#including-categorical-predictors)), it must
be added through the `dydx` option. This option shows the relationship when everything else is at it's average, so if there were no interaction, it
would simply return the coefficient on `weight`. Since we do have an interaction, it instead returns the relationship between `weight` and `mpg` when
`displacement` is at its average (recall that the coefficient on `weight` when we added the interaction becomes the relationship between `weight` and
`mpg` for 0 `displacment` cars.)

We can look at the marginal relationship for different values of `displacement` easily enough. `displacement` ranges from 79 to 425 (this can be
obtained with `summarize` or `codebook`, just don't forget to re-run the `regress` command to gain access to
the [postestimation commands](summarizing-data.html#postestimation-commands) again), so let's look at the relationship at 100, 200, 300 and 400:

~~~~
<<dd_do>>
margins, dydx(weight) at(displacement = (100 200 300 400))
<</dd_do>>
~~~~

Notice that when `displacement` is low, the p-value is very significant - amongst cars with low `displacement`, a higher weight is predicted to yield
a lower average mileage. However,

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
