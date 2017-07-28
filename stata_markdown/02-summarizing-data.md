^#^ Summarizing Data

Before we consider modeling the data in any meaningful way, it is important to explore the data to get some sense of what the data looks like, as
certain modeling decisions will depend on the structure of the data. This section and [the next](visualization.html) will cover how to examine and
visualize the data.

We will be using the built-in data set "auto" for a lot of the examples. If you're not familiar with the `sysuse` command, it functions similarly to
`use`, except only loads one of the several built-in Stata data sets.

~~~~
<<dd_do>>
sysuse auto, clear
<</dd_do>>
~~~~

The "auto" data set contains characteristics on a number of cars from 1978.

^#^^#^ `describe`, `summarize`, `codebook`

The majority of the Stata modeling commands require all variables to be numeric. String variables can be used in some places, but there are plenty of
times when you might expect them to work, but they don't. As a result, I recommend converting all categorical variables into numeric. To help with
this, the `describe` command can tell us what variables are string and which aren't.

~~~~
<<dd_do>>
describe
<</dd_do>>
~~~~

Here we can see that "make" is a string; but make is unique per row (it identifies the make and model of each car) so it's not something we're going
to use in the model. If you wanted to use string functions (see `help string functions` for details) to extract out the manufacturer of each car
(e.g. there are 7 Buicks in the data), that resultant "manufacturer" variable would be something we'd need to convert to a numeric. The main tools
you'd need would be `destring` (which converts numeric values saved as strings into numbers) and `encode` (which converts strings to numerics with
appropriate value labels).

`describe` is also useful to get a sense of the size of your data.

Once we've taken a look at the structure of the data, we can start exploring each variable. The `summarize` and `codebook` commands contains almost
the same information, presented in slightly different ways. It can be useful to look at both. For example,

~~~~
<<dd_do>>
summ price, detail
codebook price
<</dd_do>>
~~~~

Things to look for here include

- Values which are outside of expected values. The `summarize` commands gives the 1st and 99th percentiles (1% and 99% of values are below those
  thresholds, respectively) and `codebook` gives the range. If, for example, we saw a minimum value of -203 or a maximum value of 145200 (keep in mind
  these are 1978 dollars!), that's an indication that there is an issue with the data, likely a mistake.
- The mean is as expected. If this is higher or lower than expected, it might be an indication of skew or the existence of outliers. If it is very
  close to the minimum or maximum value, perhaps you have a point mass (e.g. if you polled 18-21 year olds on their number of children, there would be
  a lot of 0's but a few non-zeros).
- If the standard deviation is very small (relative to the mean), then the variable has very consistent values. A standard deviation of 0 indicates a
  constant.
- The `codebook` reports the number of missing; if you have missing data, double check that it is not an error in the
  data. Perhaps [multiple imputation](multiple-imputation.html) is needed.
- If the variable is categorical (e.g. race), is the number of unique entries reported in the `codebook` as expected?

^#^^#^ `mean`

The `mean` command gives summary statistics on the mean of a variable.

~~~~
<<dd_do>>
mean price
<</dd_do>>
~~~~

These are characteristics of the estimated mean of the "price" variable. The standard deviation reported from the `summarize` command above represenst
the variability amongst individual cars; the standard error reported by `mean` the variability of *means*: if we were to repeatedly draw samples of
size 74, the standard error is a measure of the variability of the means from all those samples.

The confidence interval is interpreted as if we were to continue drawing those samples of size 74, we would expect 95\% of those samples to have an
estimated mean within those bounds. It is *not* that we're 95% confidenct that the true population mean falls in that range - either it does or it
doesn't!

^#^^#^ Estimation Commands

The introduction of `mean` allows us to discuss estimation commands. An estimation command is any command that fits a statistical model - some of
these are obvious such as `regress` for linear regression, but others such as `mean` which we just ran are also estimation commands because it is
estimating a confidence interval. `summarize` is not because it only provides statistics about the current sample instead of making inference into the
population.

Almost all estimation commands have the same general syntax:

```
command varlist [if] [in] [weight] [,options]
```

The sections inside `[` and `]` are optional. The `command` can sometimes consist of a main command and one or more subcommands. The `varlist` can be
empty, have a single entry, or have multiple entries (the order of which is sometimes of importance - generally the first is some outcome or dependent
variable and the rest are predictors or independent variables).^[We won't cover in this class, but there are multiple-equation esimating commands
which have syntax `command (varlist) (varlist) ... (varlist) [if] [in] [weight] [,options]`. ]

Estimation commands are stored after they are run, and exist regardless of how many other non-estimation commands are run in between them. These
non-estimation commands include data manipulation and [postestimation commands](#postestimation-commands). As soon as another estimation command is
run, the first is dropped and the new one is saved.

This allows interesting things such as replaying a command (calling the estimation command again without any `varlist` to re-display it's results)
even if the data is gone!

~~~~
<<dd_do>>
clear
list
mean
<</dd_do>>
~~~~

A larger benefit of this is that if you are fitting a model on one data set and want to get predicted values on another, you could do something like
this (this is psuedo-code, not real Stata!):

```
use fitting_data
model y x1 x2
use newdata, clear
predict fitted
```

^#^^#^^#^ Postestimation commands




^#^^#^^#^ Stored results

^#^^#^ `tab`

^#^^#^ `correlate`
