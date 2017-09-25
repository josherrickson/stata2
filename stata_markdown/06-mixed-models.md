^#^ Mixed models

Let's violate another regression assumption, [independence](#independence). While this is usually thought of in the repeated measurements setting, it
is not exclusive to that. For example,

- Repeated measures: You're conducting a trial on individuals who undergo an intervention. You generate a survey, and have the participants fill out a
  copy when the intervention begins, 30 days into the intervention, and 1 year after the intervention. If we have a single outcome measure of interest
  from this survey, we have three measurements for person. These values are not independent; it's reasonable to think that your measurements are more
  related to each other than any of mine.
- Non-repeated measures: You conduct door-to-door sampling of individuals in households, asking about food habits. You collect information on each
  individual in the house, and want to use individuals as the unit of analysis. It's likely that two individuals in the same house will have similar
  food patterns, as opposed to two individuals from different houses.

To address the lack of dependence, we will move from normal regression (linear or otherwise) into a mixed models framework, which accounts for this
dependence structure. It does this (at the most basic level) by allowing each [individual from the intervention example, household from the
door-to-door example] to have its own intercept which we *do not estimate*.

For this chapter, we'll turn away from the "auto" data set and instead use a sample of
the ["National Longitudinal Survey"](https://en.wikipedia.org/wiki/National_Longitudinal_Surveys) contained in Stata:

~~~~
<<dd_do>>
webuse nlswork, clear
<</dd_do>>
~~~~

This data is a survey taken from 1968-1988, and this specific sample of the data is salary information for women. We have repeated measures in the
sense that we have yearly data for women, so each woman can have up to 20 data points.

^#^^#^ Terminology

There are several different names for mixed models which you might encounter, that all fit essentially the same model:

- Mixed model
- Mixed Effects regression
- Multilevel regression
- Hierarchical regression (specifically HLM, heirarchical linear model)

The hierarchical/multilevel variations require thinking about the levels of the data and involves "nesting", where one variable only occurs within
another, e.g. family members nested in a household. The most canonical example of this is students in classrooms, we could have

- Level 1: The lowest level, the students.
- Level 2: Classroom or teacher (this could also be two separate levels of classrooms inside teacher)
- Level 3: District
- Level 4: State
- Level 5: Country

This is taking it a bit far; it's rare to see more than 3 levels, but in theory, any number can exist.

For this workshop, we will only briefly discuss this from hierarchical point of view, prefering the mixed models view (with the reminder again that
they are the same!).

^#^^#^ Wide vs Long data, Time-varying vs Time-invariant

Before you begin your analysis, you need to ensure that the data is in the proper format. Let's consider the NLS data, where we have measures of
women's salary over 20 years.

Wide format of the data would have row represent a woman, and she would have 20 columns worth of salary information (plus additional demographics).

Long format of the data would have each row represent a woman and a year, so that each woman can have up to 20 rows (if a woman wasn't measured in a
given year, that row & year is blank).

To fit a mixed model, we need the data in long format. We can use the `reshape` command to transform wide data to long. This is covered in the Stata I
set of notes.

Additionally, there is the concept of time-varying vs time-invariant variables. Time-varying variables are those which can be different for each entry
within the same individual. Examples include weight or salary. Time-invariant are those which are the same across all entries. Examples include race
or baseline characteristics.

When data is long, time-invariant variables need to be constant per person.

^#^^#^ Linear Mixed Model

The most basic mixed model is the linear mixed model, which extends the [linear regression](#linear-regression) model. A model is called "mixed"
because it contains a mixture of *fixed effects* and *random effects*.

- Fixed effects: These are the predictors that are present in regular linear regression. We will obtain coefficients for these predictors and be able
  to test and interepret them. Technically, an OLS linear model is a mixed model with only fixed effects.^[Though why called it mixed at that point?]
- Random effects: These are the "grouping" variables, and must be categorical (Stata will force every variable to be prefaced by `i.`). These are
  essentially just predictors as well, however, we do not obtain coefficients to test or interpret. We do get a measure of the variability across
  groups, and a test of whether the random effect is benefitting the model.

Let's fit a model using the `mixed` command. It works similar to `regress` with a slight tweak. We'll try and predict log of wages^[Typically, salary
information is very right-skewed, and a log transformation produces normality.] using work experience and race. This data

~~~~
<<dd_do>>
mixed ln_w ttl_exp i.race age || idcode:
<</dd_do>>
~~~~

The fixed part of the equation, `ln_w ttl_exp i.race age` is the same as with linear regression, `ln_w` is the outcome and the rest are predictors,
with `race` being categorical. The new part is `|| idcode:`. The `||` separates the fixed on the left from the random effects on the right. `idcode`
identifies individuals. The `:` is to enable the more complicated feature of random slopes which we won't cover here; for our purposes the `:` is just
required.

Let's walk through the output. Note that what we are calling the random effects (e.g. individuals in a repeated measures situation, classrooms in a
students nested in classroom situation), Stata refers to as "groups" in much of the output.

- At the very top, you'll see that the solution is arrived at iteratively, similar to [logistic regression](#fitting-the-logistic-model) (you probably
  also noticed how slow it is)!
- The log likelihood is how the iteration works; essentially the model "guesses" choices for the coefficients, and finds the set of coefficeints that
  minimize the log likelihood. Of course, the "guess" is much smarter than random. The actual value of the log likelihood is meaningless.
- Since we are dealing with repeated measures of some sort, instead of a single sample size, we record the total number of obs, the number of groups
  (unique entries in the random effects) and min/mean/max of the groups. As before, just ensure these numbers seem right.
- As with logistic regression, the ^$^\chi^2^$^ test tests the hypothesis that all coefficients are simultaneously 0.
    - We gave a significant p-value, so we continue with the interpretation.
- The coefficients table is interpreted just as in linear regression, with the addendum that each coefficient is also controlling for the structure
  introduced by the random effects.
    - Increased values of `ttl_exp` is associated with higher log incomes.
    - The `race` baseline is "white"; compared to white, blacks have lower average income and others have higher average income.
    - Higher age is associated with lower income.
- The second table ("Random-effects parameters") gives us information about the error structure. The "idcode:" section is examining whether there is
  variation across individuals above and beyond the differences in characteristics such as age and race. Since the estimate of `var(_cons)` (the
  estimated variance of the constant per person - the individual level random effect) is non-zero (and not close to zero), that is evidence that the
  random effect is beneficial. If the estimate was 0 or close to 0, that would be evidence that the random effect is unnecessary and that any
  difference between individuals is already accounted for by the covariates.
- The estimated variance of the residuals is any additional variation between observations. This is akin to the residuals from linear regression.
- The ^$^\chi^2^$^ test at the bottom is a formal test of the inclusion of the random effects versus a [linear
  regression](regression.html#linear-regression) model without the random effects. We reject the null that the models are equivalent, so it is
  appropriate to include the random effects.

^#^^#^ Assumptions



What to do if you don't converge

^#^^#^ Logistic Mixed Model
