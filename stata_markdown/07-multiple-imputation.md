^#^ Multiple Imputation

Multiple imputation is a common approach to addressing missing data issues. When there is missing data, the default results are often obtained with
complete case analysis (using only observations with complete data) can produce biased results [though not always](#missing-at-random). Additionally,
complete case analysis can have a severe negative effect on the power by greatly reducing the sample size.

Imputation in general is the idea of filling in missing values to simulate having complete data. Some simpler forms of imputation include:

- Mean imputation. Replace each missing value with the mean of the variable for all non-missing observations.
- Cold deck imputation. Replace each missing value with the value from another observation which is similar to the one with the missing value.
- Regression imputation. Fit a regression model and replace each missing value with its predicted value.

There are various pros and cons to each approach, but in general, none are as powerful or as commonly used as multiple imputation. Multiple imputation
(or MI) is a three step procedure:

1. For each missing value, obtain a distribution for it. Sample from these distributions to obtain imputed values that have some randomness built
   in. Do this repeatedly to create ^$^M^$^ total imputed data sets. Each of these ^$^M^$^ data sets is identical on non-missing values but will
   (almost certainly) differ on the imputed values.
2. Perform your statistical analysis on each of the ^$^M^$^ imputed data sets separately.
3. Pool your results together in a specific fashion to account for the uncertainty in imputations.

Thankfully, for simple analyses (e.g. most regression models), Stata will perform all three steps for you automatically. We will briefly discuss later
how to [perform MI if Stata doesn't support it](#manual-mi).

^#^^#^ Missing at random

There can be many causes of missing data. We can classify the reason data is missing into one of three categories:

1. **Missing completely at random (MCAR)**: This is missingingess that is truely random - there is no cause of the missingness, it's just due to
   chance. For example, you're entering paper surveys into a spreadsheet and spill coffee on them, obscuring a few answers.
2. **Missing at random (MAR)**: The missingness here is due to observed data but not unobserved data. For example, women may be less likely to report
   their age, regardless of what their actual age is.
3. **Missing not at random (MNAR)**: Here the missingness is due to the missing value. For example, individuals with higher salary may be less willing
   to answer survey questions about their salary.

There is no statistical test^[There is technically Little's MCAR test to compare MCAR vs MAR, but the majority of imputation methods require only MAR,
not MCAR, so it's of limited use. Additionally, it is not yet supported in Stata.] to distinguish between these categories; instead you must use your
knowledge of the data and its collection to argue which category it falls under.

This is important because most imputation methods (including MI) require MCAR or MAR for the data. If the data is MNAR, there is very little you can
do. Generally if you believe the data is MNAR, you can assume MAR but discuss that a severe limitation of your analysis is the MAR assumption is
likely invalid.

^#^^#^ `mi`

The `mi` set of commands in Stata perform the steps of multiple imputation. There are three steps, with a preliminary step to examine the
missingness. We'll be using the "mheart5" data from Stata's website which has some missing data.

~~~~
<<dd_do>>
webuse mheart5, clear
describe, short
summarize
<</dd_do>>
~~~~

We see from the summary that both `age` and `bmi` have some missing data.

^#^^#^ Setting up data

We need to tell Stata how we're going to be doing the imputations. First, use the `mi set` command to determine how the multiple data sets will be
stored. Really which option you choose is up to you, I prefer to "`flong`" option, where each imputed data set is stacked on top of each other. If you
have very large data, you might prefer "`wide`", "`mlong`" or "`mlongsep`", the last of which stores each imputed data set in a separate file. See
`help mi styles` for more details. (Ultimately the decision is not that important, as you can switch later using `mi convert <new style>`.)

~~~~
<<dd_do>>
mi set flong
<</dd_do>>
~~~~

Next, we need to tell Stata what each variable will be used for. The options are

- imputed: A variable with missing data that needs to be imputed.
- regular: Any variable that is complete or does not need imputation.

Technically we only need specify the imputed variables, as anything unspecified is assumed to be regular. We saw [above](#mi) that `age` and `bmi`
have missing values:

~~~~
<<dd_do>>
mi register imputed age bmi
<</dd_do>>
~~~~

We can examine our setup with `mi describe`:

~~~~
<<dd_do>>
mi describe
<</dd_do>>
~~~~

We see 126 complete observations with 28 incomplete, the two variables to be imputed, and the 4 unregisted variables which will automatically be
registered as regular.

^#^^#^^#^ Imputing transformations

What happens if you had a transform of a variable? Say you had a variable for salary, and wanted to use a log transformation?

You can find literature suggesting either transforming first and then imputing, or imputing first and then transforming. Our suggestion, following
current statistical literature is to **transform first, impute second**.([Hippel 2009](#citations))

Stata technically supports the other option via `mi register passive`, but we don't recommend it's usage. Instead, transform your original data, then
flag both the variable and its transformations as "imputed"

^#^^#^ Performing the imputation

Now that we've got the MI set up, we can perform the actual procedure. There are a very wide number of variations on how this imputation can be done
(including defining your own!). You can see these as the options to `mi impute`. We'll just be focusing on the "chained" approach, which is a good
approach to start with.

The syntax for this is a bit complicated, but straightforward once you understand it.

```
mi impute chained (<method 1>) <variables to impute with method 1> ///
                  (<method 2>) <variables to impute with method 2> ///
                  = <all non-imputed variables>, add(<number of imputations>)
```

The "<methods>" are essentially what type of model you would use to predict the outcome. For example, for continuous data, use `regress`. For binary
data use `logit`. It also supports `ologit` (ordinal logistic regression, multiple categories with ordering), `mlogit` (multinomial logistic
regression, multiple categories without ordering), `poisson` or `nbreg` (poisson regression or negative binomial regression, for count data), as well
as some others. See `help mi impute chained` under "uvmethod" for the full list.

The `add( )` option specifies how many imputed data sets to generate, we'll discuss [below](#choosing-the-number-of-imputations) how to choose this.

Continuning with our example might make this more clear. To perform our imputation, we would use

~~~~
<<dd_do>>
mi impute chained (regress) bmi age = attack smokes female hsgrad, add(5)
<</dd_do>>
~~~~

Since both `bmi` and `age` are continuous variables, we use method `regress`. Imagine if we were also imputing `smokes`, a binary variable. Then the
imputation (after running `mi register imputed smokes`) would be:

```
mi impute chained (regress) bmi age (logit) smokes = attack female hsgrad, add(5)
```

Here, `regress` was used for `bmi` and `age`, and `logit` was used for `smokes`.

^#^^#^^#^ Choosing the number of imputations

Classic literature has suggested you need only 5 imputations to obtain valid results, though some modern literature ([Graham 2007](#citations))
suggest needing many more, 20 or even 100. If your data is not too large, 100 is a great choice. You can always try running the entire procedure with
5 imputations twice. If your results differ, you should try running many more imputations to stablize the estimates.

^#^^#^^#^ `_mi_` variables

After you've performed your imputation^[Techincally this happens as soon as you run `mi set`, but they're not interesting until after `mi impute`.],
three new variables are added to your data, and your data gets ^$^M^$^ additional copies of itself. In the example
[above](#performing-the-imputation), we added 5 imputations, so there are a total of 6 copies of the data - the raw data (with the missing values),
and 5 copies with imputed values. The new variables added are:

- `_mi_id` is the ID number of each row corresponding to its position in the original data
- `_mi_miss` flags whether the row had missing data originally.
- `_mi_m` is which data-set we're looking at. 0 represents the unimputed data, 1 represents the first imputation, 2 the second, etc.

^#^^#^ Analyzing `mi` data

Now that we've got the data set up for multiple imputations, and done the imputation, most of the hard part is over. Analyzing MI data is
straightforward, usually. (When it isn't, you can do this [manually](#manual-mi).)

Basically, take any analysis command you would normally run, e.g. `regress y x`, and preface it by `mi estimate:`. Let's try to predict the odds of a
heart attack based upon other characteristics in the data. We would run a [logistic regression model](regression.html#logistic-regression),

```
logit attack smokes age bmi female hsgrad
```

So to run it with multiple imputations:

~~~~
<<dd_do>>
mi estimate: logit attack smokes age bmi female hsgrad
<</dd_do>>
~~~~

We see a single model, even though 5 models (one for each imputation) were run in the background. The results from these models were pooled using
something called "Rubin's rules" to produce a single model output.

We see a few additional fit summaries about the multiple imputation that aren't super relevant; but otherwise all the [existing
interpretations](regression.html#fitting-the-logistic-model) hold. Note that an F-test instead of ^$^\chi^2^$^ test is run, but still tests the same
hypothesis that all coefficients are identically zero. Among the coefficients, we see that smokers have significantly higher odds of having a heart
attack, and there's some weak evidence that age plays a role.

^#^^#^^#^ MI Postestimation

In general, most postestimation commands will not work after MI. The general approach is to do the MI [manually](#manual-mi) and run the
postestimation for each imputation. One exception is that `mi predict` works how `predict` does.

^#^^#^ Manual MI

Since we set the data as [`flong`](#setting-up-data), each imputed data set lives in the data with a separate
[`_mi_m`](multiple-imputation.html#mi-variables) value. You can conditionally run analyses on each, e.g.


```
logit attack smokes age bmi female hsgrad if _mi_m == 0
```

to run the model on only the original data.

It is tedious to do this over all imputed data, so instead we can run `mi xeq:` as a prefix to run a command on each separate data set. This is
similar to `mi estimate:` except without the pooling.

~~~~
<<dd_do>>
mi xeq: summ age
<</dd_do>>
~~~~

This can also be useful if the analysis you want to execute is not supported by `mi estimate` yet.

^#^^#^^#^ Rubin's rules

If you wanted to pool the results yourself, you can obtain an estimate for the pooled parameter by simple average across imputations. The forumla for
variance is slightly more complicated so we don't produce it here, however it can be found in the "Methods and formulas" section of the MI manual (run
`help mi estimate`, click on "[MI] mi estimate" at the top of the file to open the manual.

^#^^#^ Removing the MI data

Ideally, you should save the data (or `preserve` it) prior to imputing, so you can easily recover the unimputed data if you wish. If you wanted to
return to the original data, the following should work:

```
mi unset
drop if mi_m != 0
drop mi_*
```

The first tells Stata not to treat it as imputed anymore; the second drops all imputed data sets; the third removes the MI variables that were
generated.

This only works for `mi set flong`; if you use another method, you can tweak the above or use `mi convert flong` to switch to "flong" first.

^#^^#^ Citations

Von Hippel, Paul T. "How to impute interactions, squares, and other transformed variables." Sociological Methodology 39.1 (2009): 265-291.
