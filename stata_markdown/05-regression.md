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
reload the auto data and fit a relatively simple model, predicting `mpg` based on `gear_ratio` and `headroom`.

~~~~
<<dd_do>>
regress mpg gear_ratio headroom
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
  if the predictor being added is either constant or identical to another variable.] This makes ^$^R^2^$^ poor for model comparison, as it would
  always select the model with the most predictors. Instead, the adjusted ^$^R^2^$^ ("Adj R-Squared") accounts for this; it penalizes the ^$^R^2^$^ by
  the number of predictors in the model. Use the ^$^R^2^$^ to measure model fit, use the adjusted ^$^R^2^$^ for model comparison.
- The root mean squared error ("Root MSE", as known as RMSE) is a measure of the average difference between the observed outcome and the predicted
  outcome. It can be used as another measure of model fit, as it is on the scale of the outcome variable. So for this example, the RMSE is
  <<dd_display: %9.4f e(rmse)>> so the average error in the model is about <<dd_display: %9.1f e(rmse)>> mpg.

Finally, we get to the coefficient table. Each row represents a single predictor. The "\_cons" row is the intercept; it's Coef. of
<<dd_display: %9.4f _b[_cons]>> represents the average response *when all other predictors are 0*. This is usually not interesting; how many cars
weighing 0 lbs do you know of? So we'll ignore this and instead go over the other rows.

- "Coef.": These are the ^$^\beta^$^ from the above model. We interpret each as "For a 1 increase in the value of the covariate with all other
  predictors held constant, we would predict this change in the response, on average." For example, for every additional inch^[This is why it's
  important to familiarize yourself with the units in your data!] of headroom in a car (while its gear ratio is constant), it is predicted to have an
  average of <<dd_display: %9.4f abs(_b[headroom])>> lower mpg.
- "Std. Err.": This represents the error attached to the coefficient. This is rarely interpreted; but if it gets extremely large or extremely small
  (and the Coef. doesn't likewise go to extremes), its an indication there may be something wrong.
- "t": This is the standardized coefficient, calculated as Coef./Std. Err. We can't directly compare the Coef.'s because of the different scales, but
  we can examine the standardized coefficients to get a sense of which predictor has a larger impact. In this model, we see that the impact of weight
  is much more than the impact of displacement.
- "P>|t|": The p-value testing whether the coefficient is significantly different than 0. In this model, we see that both `gear_ratio` and `headroom`
  have significant p-values.
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
regress mpg gear_ratio headroom rep78
<</dd_do>>
~~~~

We only get a single coefficient. Stata is treating `rep78` as continuous. When including a categorical predictor, Stata will create dummy variables
(variables which take on value 1 if the observation is in that category and 0 otherwise) and include all but one, which is the refernce (or
baseline). Since we only see a single coefficient here, we know Stata did it incorrectly.

The issue is that Stata doesn't know we want to treat `rep78` as categorical. If we prefix the variable name with `i.`, Stata will know it is
categorical.

~~~~
<<dd_do>>
regress mpg gear_ratio headroom i.rep78
<</dd_do>>
~~~~

First, note that `headroom` no longer has a significant coefficient! This implies that `rep78` and `headroom` are correlated, and in the first model
where we did not include `rep78`, all of `rep78`'s effect was coming through `headroom`. Once we control for `rep78`, headroom is no longer
significant. We will discuss [multicollinearity later](#miscellaneous-concerns), as well as why this is
why [model selection is bad](#miscellaneous-concerns).

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

The first `margins` call, without any options, displays the marginal means for each category - if every car had `rep78` at those levels, it's the
average predicted mileage of all cars. The t-test here is useless - it's only testing that the average mileage of the cars in each group is not 0!

The second `margins` call adds the `pwcompare(pv)` option, which performs pairwise test between each pair of `rep78` levels. This is similar to a
post-hoc test from ANOVA if you are familiar with it. The only statistical significance we find is 5 vs 3 and 5 vs 4, suggesting that 5 is dissimilar
from 3 and 4. (Confusingly, 3 and 4 are not dissimilar from 1 or 2, but 5 is similar to 1 and 2! These sort of things can happen; its best to focus
only on the comparisons that are of theoretical interest.)

By default, using `i.` makes the first level (lowest numerical value) as the reference category. You can adjust this by using `ib#.` instead, such as:

~~~~
<<dd_do>>
regress mpg headroom gear_ratio ib3.rep78
<</dd_do>>
~~~~

^#^^#^^#^ Interactions

Each coefficient we've look at so far is only testing whether there is a relationship between the predictor and response when the other predictors are
held constant. What if we think the relationship changes based on the value of other predictors? For example, we might be interested in whether the
relationship between a car's headroom and its mileage depends on it's gear ratio. Perhaps we think that cars with higher gear ratio (a high gear ratio
is indicative of a sportier car) won't be as affected by headroom as a standin for size, because sportier cars generally are better made.

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
regress mpg c.headroom##c.gear_ratio i.rep78
<</dd_do>>
~~~~

Note that we used `c.`, similar to `i.`. `c.` forces Stata to treat it as continuous. Stata assumes anything in an interaction is categorical, so we
need `c.` here! This can get pretty confusing, but it's never wrong to include `i.` or `c.` when specifying a regression.

Once we include an interaction, the relationship between the variables included in the interaction and the response are not constant - the
relationship depends on the value of the other interacted variables. This can be hard to visualize with the basic regression output, so we'll look at
`margins` again instead. We'll want to look at the relationship between `mpg` and `weight` at a few different values of `displacement` to get a sense
of the pattern. `displacement` ranges from 79 to 425 (this can be obtained with `summarize` or `codebook`, just don't forget to re-run the `regress`
command to gain access to the [postestimation commands](summarizing-data.html#postestimation-commands) again), so let's look at the relationship at
100, 200, 300 and 400:

~~~~
<<dd_do>>
margins, dydx(weight) at(displacement = (100 200 300 400))
<</dd_do>>
~~~~

Notice that when `displacement` is low, the p-value is very significant - amongst cars with low `displacement`, a higher weight is predicted to yield
a lower average mileage. However,

Follow this with a call to `marginsplot` for a great visualization:

~~~~
<<dd_do>>
marginsplot
<</dd_do>>
~~~~

<<dd_graph: replace>>

With low displacement, there is a negative relationship between weight and mileage - adding weight to a low displacment car is predicted to decrease
mileage, on average. However, the effect decreases as displacment increases, and at high levels of displacement, there is no longer any relationship
(you can detect this both because the t-test from the `margins` call for `displacement = 400` is not significant, and becaues the confidence interval
in the `marginsplot` crosses zero).

^#^^#^^#^ Assumptions:

There are three main assumptions when running a linear regression. Some we can test, some we cannot (and need to rely on our knowledge of the data).

^#^^#^^#^^#^ Relationship is linear and additive

Recall the linear regression model:

^$$^
  Y = \beta_0 + \beta_1X_1 + \beta_2X_2 + \cdots + \beta_pX_p + \epsilon
^$$^

This very explicitly assumes that the relationship is linear (as opposed to something non-linear, such as quadratic or exponential) and additive (as
opposed to multiplicative). We can examine this assumption by looking at plots of the residuals (estimated errors):

~~~~
<<dd_do>>
rvfplot
<</dd_do>>
~~~~

<<dd_graph: replace>>

What we're seeing here is a scatterplot between the fitted values (the predicted values for each individual) and their errors (the difference between
the predicted values and observed values). If you can see a pattern in the scatterplot, that is evidence that this assumption is
violated. **Importantly**, not seeing any pattern is **not** evidence that the assumption is valid! You'll still need to cover this assumption with
theory and knowledge of the data.

This image, from Julian Faraway's [Linear Models with R](http://www.maths.bath.ac.uk/~jjf23/LMR/) book, demonstrates a lack of pattern (the first) and
a pattern (the third). (We will discuss the second plot [below](#errors-are-homogeneous)).

![](https://i.stack.imgur.com/rtn7e.png)

If this assumption is violated, you will need to reconsider the structure in your model, perhaps by adding a squared term (e.g. `reg y c.x c.x#c.x`).

^#^^#^^#^^#^ Errors are homogeneous

"Homogeneity" is a fancy term for "uniform in distribution", whereas "heterogeneity" represents "not uniform in distribution". If we were to take a
truly random sample of all individuals in Michigan, the distribution of their heights would be homogeneous - it is reasonable to assume there is only
a single distribution at work there. If on the other hand, we took a random sample of basketball players and school children, this would definitely be
heterogeneous, the basketball players have a markedly difference distribution of heights that school children!

In linear regression, the homoegenity assumption is that the distribution of the errors are uniform. Violations would include errors changing as the
predictor increased, or several groups having very different noise in their measurements.

This is an assumption we can test, again with the residuals vs fitted plot. We're looking for either a blatant deviation from a mean of 0, or an
increasing/decreasing variatbility on the y-axis over time. Refer back to the [image above](#relationship-is-linear-and-additive), looking at the
middle plot. As the fitted values increase, the error spreads out.

If this assumption is violated, you may consider restructuring your model as above, or transforming either your response or predictors using log
transforms.

^#^^#^^#^^#^ Independence

This last assumption is that each row of your data is independent. If you have repeated measures, this is violated. If you have subjects drawn from
groups (i.e. students in classrooms), this is violated. There is no way to test for this, it requires knowing the data set.

If this assumption is violated, consider fitting a [mixed model](mixed-models.html) instead.

^#^^#^^#^ Miscellaneous concerns

Multicollinearity is an issue when 2 or more predictors are correlated. If only two are correlated, looking at their correlation (with `pwcorr` or
`correlate`) may provide some indication, but you can have many-way multicollinearity where each pairwise correlation is low. You can use the variance
inflation factor to try and indentify if this is an issue.

~~~~
<<dd_do>>
estat vif
<</dd_do>>
~~~~



- Confounding
- Overfitting 1:10 or 1:20
- Why model selection is bad


^#^^#^ Logistic

^#^^#^ Poisson Maybe
