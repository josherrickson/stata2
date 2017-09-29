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

^#^^#^ Step 1: Setting up data

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
-

^#^^#^ Performing the imputation

^#^^#^ Analyzing `mi` data

^#^^#^ Manual MI
