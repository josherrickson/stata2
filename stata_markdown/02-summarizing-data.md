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
  close to the minimum or maximum value, perhaps you have a point mass (e.g. if you polled 18-21 year old's on their number of children, there would be
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

These are characteristics of the estimated mean of the "price" variable. The standard deviation reported from the `summarize` command above represents
the variability among individual cars; the standard error reported by `mean` the variability of *means*: if we were to repeatedly draw samples of
size 74, the standard error is a measure of the variability of the means from all those samples.

The confidence interval is interpreted as if we were to continue drawing those samples of size 74, we would expect 95\% of those samples to have an
estimated mean within those bounds. It is *not* that we're 95% confident that the true population mean falls in that range - either it does or it
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
variable and the rest are predictors or independent variables).^[We won't cover in this class, but there are multiple-equation estimating commands
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
this (this is pseudo-code, not real Stata!):

```
use fitting_data
model y x1 x2
use newdata, clear
predict fitted
```

^#^^#^^#^ Postestimation commands

Since the last estimation command is saved, any commands which need to reference it (called postestimation commands) do so inherently, no need to
specify. For example, let's reload the data and run `mean` on a few variables.

~~~~
<<dd_do>>
sysuse auto, clear
mean mpg headroom length
<</dd_do>>
~~~~

Let's say we want to obtain the correlation matrix^[We could just run `correlate`, but the postestimation commands following `mean` are fairly
limited, so bare with me here. Postestimation commands following models are much more interesting!]

~~~~
<<dd_do>>
estat vce, corr
<</dd_do>>
~~~~

Here we see that both `length` and `headroom` are negatively correlated with `mpg`; as the car gets larger, its mileage decreases. Headroom and length
are positively correlated, so cars aren't just growing in one direction!

The `estat` command is somewhat generic, we will see other uses of it later.

Similar to how you can get help with any command with help, e.g. `help mean`, you can get a list of all postestimation commands that a given
estimation command supports:

```
help mean postestimation
```

There is also a link to the postestimation page in the help for the estimation command.

^#^^#^^#^ Storing and restoring estimation commands

The obvious downside to Stata's approach to saving the most recent estimation command is that you lose all earlier commands. If you have only a
limited number of commands and each is fast, this isn't a big deal. However, with some
more [advanced](mixed-models.html) [approaches](multiple-imputation.html), modeling can become very slow, so you may not want to lose the
results. Stata has a solution for this, allowing us to store and recall estimation commands without having to re-run them. This has an obvious
parallel to the `preserve`/`restore` commands that affect the data.

You have the choice of saving the results temporarily (in memory) or permanently (to a file). There are the obvious pro's and con's to each
approach. For these notes I will focus primarily on storing the results in memory, but I will point out where the commands differ if saving to a
file. Let's run a fresh `mean` call to work with. The `estimates` command will be used.

~~~~
<<dd_do>>
mean price mpg
estimates query
<</dd_do>>
~~~~

The `query` subcommand tells us what estimation command was last run, and whether it has already been saved. Here it has not. Let's save these
results.

~~~~
<<dd_do>>
estimates store mean1
<</dd_do>>
~~~~

To save to a file, use `estimates save` instead. Now let's run a second `mean` commands.

~~~~
<<dd_do>>
mean mpg headroom length
est store mean2
est query
<</dd_do>>
~~~~

Now `query` is telling us that the current estimation commands are (obviously) stored as "mean2". Let's use `estimates restore` to jump between the
two. (If saving to a file, use `estimates use` instead.)

~~~~
<<dd_do>>
est restore mean1
estat vce, corr
est query
<</dd_do>>
~~~~

To "replay" an estimation command (re-display the results without re-running the model), you can either restore it and call the blank command again:

~~~~
<<dd_do>>
est restore mean2
mean
<</dd_do>>
~~~~

or use `estimates replay` directly:

~~~~
<<dd_do>>
est query
est replay mean1
<</dd_do>>
~~~~

One use of stored estimates that can be useful is creating a table to include all the results.

~~~~
<<dd_do>>
est table mean1 mean2
<</dd_do>>
~~~~

If you are familiar with regression, you should be able to see how useful this might be!

Finally, we can see all saved commands with `dir`, drop a specific estimation command with `drop`, or remove all with `clear`:

~~~~
<<dd_do>>
est dir
est drop mean1
est dir
est clear
est dir
<</dd_do>>
~~~~

^#^^#^ `tab`

Continuing on with exploring the data, categorical variables are not summarized well by the mean. Instead, we'll look at a tabulation.

~~~~
<<dd_do>>
tabulate rep78
<</dd_do>>
~~~~

This gives us the count at each level, the percent at each level, as well as the cumulative percent (e.g. 57.97% of observations have a value of 3 or
below). The cumulative percentage is only informative for an ordinal variable (a categorical variable that has an ordering too it), and not an
unordered categorical variable such as race.

Note that it is counting a total of 69 observations to total 100\% of the data. However, you may have noticed earlier that we have 74 rows of data. By
default, `tabulate` does *not* include any information about missing values. The `missing` option corrects that.

~~~~
<<dd_do>>
tab rep78, missing
<</dd_do>>
~~~~

It's important to keep in mind the difference between the percentages of the two outputs. For example, 11.59% of *non-missing* values of `rep78` are
2, whereas only 10.81% of *all* values are 2.

There are a few other options related to how the results are visualized which we will not cover.

^#^^#^^#^ Two-way tables

We will cover two-way tables (also known as "crosstabs") later in [univariate analysis](univariate-and-some-bivariate-analysis.html#chi-square-test),
but there is a peculiarity to `tab` related to it. If you pass two variables to `tab`, it creates the crosstab:

~~~~
<<dd_do>>
tab rep78 foreign, missing
<</dd_do>>
~~~~

What if instead you wanted each individual table? You could run multiple `tab` statements, or use the `tab1` command instead.

~~~~
<<dd_do>>
tab1 rep78 foreign, missing
<</dd_do>>
~~~~

If you give more than two arguments to `tab`, it will not run. If you wanted all pairwise tables, you can use `tab2`:

~~~~
<<dd_do>>
tab2 rep78 foreign headroom, missing
<</dd_do>>
~~~~

^#^^#^^#^ Generating dummy variables

Although Stata has excellent categorical variable handling capabilities, you may occasionally have the situation where you want the dummy variables
instead of a category. For an example of the difference, consider a "campus" variable with three options, "central", "north" and "medical". Imagine
our data looks like:

| `id` | `campus` | `campuscentral` | `campusnorth` | `campusmedical` |
|:----:|:---------|:---------------:|:-------------:|:---------------:|
| 1    | north    | 0               | 1             | 0               |
| 2    | central  | 1               | 0             | 0               |
| 3    | north    | 0               | 1             | 0               |
| 4    | north    | 0               | 1             | 0               |
| 5    |medical   | 0               | 0             | 1               |

Notice that the information in `campus` and the information encoded in `campuscentral`, `campusnorth`, and `campusmedical` are identical. A 1 in the
`campus____` variables represents "True" and 0 represents "False", and only a single 1 is allowed per row.

As mentioned, we will most of the time use categorical variables such as `campus` over dummy variables like `campus_____` (these are used in the
actual model, but Stata creates them for you behind the scenes so you don't need to worry about them), but if necessary, you can create the dummy
variables using `tab`:

~~~~
<<dd_do>>
list rep* in 1/5
tab rep78, gen(reps)
list rep* in 1/5
<</dd_do>>
~~~~

If you are not familiar with the `list` command, it prints out data. Giving it a variable (or multiple) restricts it to those (here we restricted it
to `rep\*`, which is any variable that starts with "rep" - the \* is a wildcard), and the `in` statement restricts to the first 5 observations (we
just want a quick visualization, not to print everything).

Take note of how the missing value is treated when creating the dummies.

^#^^#^ `correlate`

With the use of `tab` and `tab2` for crosstabs, we've left univariate summaries and moved to joint summaries. For continuous variables, we can use the
correlation to examine how similar two continuous variables are. The most common version of correlation is Pearson's correlation, which ranges from -1
to 1. A value of 0 represents no correlation, a value of 1 represents perfect correlation, a value of -1 represents perfect negative correlation. We
can calculate the Pearson's correlation with `correlate`.

~~~~
<<dd_do>>
correlate weight length
<</dd_do>>
~~~~

This produces whats known as the correlation matrix. The diagonal entries are both 1, because clearly each variable is perfectly correlated with
itself! The off-diagonal entries are identical since correlation is a symmetric operation. The value of .95 is extremely close to one, as we would
expect - longer cars are heavier and perhaps vice-versa. Another way to think of it is that once we know `weight`, learning `length` does not add much
information. On the other hand,

~~~~
<<dd_do>>
corr price turn
<</dd_do>>
~~~~

with a correlation of .31, learning `turn` when you already know `price` does add a lot of information.

We can look at multiple correlations at once as well.

~~~~
<<dd_do>>
corr mpg weight length
<</dd_do>>
~~~~

We see the .9460 we saw earlier, but notice also that `mpg` is negatively correlated with both `weight` and `length` - a larger car gets worse mileage
and low mileage cars tend to be large. A few notes:

- The amount of information contained is irrespective of the sign; knowing the `mpg` of a car, adding information about its `weight` doesn't add much
  information.
- The two correlations with `mpg` are extremely similar. We might generally expect that, given that `weight` and `length` are so strongly
  correlated. Note that despite that we expect that, it is not a rule - it is entirely possible (though unlikely) that the correlations with `mpg`
  could be very dissimilar.

^#^^#^^#^ varlists in Stata

Consider if we wanted to look at all the continuous variables in the data. We could write `corr price mpg ...` and make a very long command. The
collection of all variables would be a "varlist". Stata has several ways of short cutting this.

The first we've already seen when we used the wildcard "\\*" [above](#Generating-dummy-variables). We can use \* anywhere in the variable name to
denote any number of additional characters. E.g. "this\*var" matches "thisvar", "thisnewvar", "this-var", "thisHFJHDJSHFKDHFKSHvar", etc. A second
wildcard, "?", represents just a single variable, so "this\*var" would match only "this-var" from that list, as well as "thisAvar", "thisJvar", etc.

Secondly, we can match a subset of variables that are next to each other using "-". All variable, starting with the one to the left of the - and
ending with the one to the right of the - are included. For example,

~~~~
<<dd_do>>
desc, simple
desc trunk-turn
<</dd_do>>
~~~~

We can combine those two, as well as specifying individual variables.

~~~~
<<dd_do>>
corr price-rep78 t* displacement
<</dd_do>>
~~~~

`price`, `mpg` and `rep78` are included as part of `price-rep78`, `t\*` matches `trunk` and `turn`, and `displacement` is included by itself.

Finally, there is the special variable list `\_all`, which is shorthand for all variables (e.g. `firstvar-lastvar`). It is accepted in most but not
all places that take in variables.

~~~~
<<dd_do>>
corr _all
<</dd_do>>
~~~~

Notice that it automatically ignored the string variable `make`. Not all commands will work this well, so `\_all` may occasionally fail.

^#^^#^^#^ Pairwise completion vs complete case

You may have noticed that the `cor` command reports the number of observations it used, for example, the first few correlations all used 74
observations, but the `\_all` version used on 69. `correlate` uses what's known as complete cases analysis - any observation missing *any* value used
in the command is excluded. `rep78` is missing 5 observations (run the `misstable summarize` command to see this).

On the other hand, pairwise completion only excluded missing values from the relevant comparisons. If a given correlation doesn't involve `rep78`, it
will use all the data. We can obtain this with `pwcorr`.

~~~~
<<dd_do>>
corr rep78 price trunk
pwcorr rep78 price trunk
<</dd_do>>
~~~~

Notice the two correlations involving `rep78` are identical - the same set of observations are dropped in both. However, the correlation between
`price` and `trunk differs - in `correlate`, it is only using 69 observations, whereas in `pwcorr` it uses all 74.

It may seem that `pwcorr` is always superior (and, in isolation it is). However, most models such as [regression](regression.html) only support
complete cases analysis, so in those cases, if you are exploring your data, it does not make sense to do pairwise comparison. Ultimately, the choice
remains up to you. If the results from `correlate` and `pwcorr` do differ drastically, that is a sign of something else going on!

^#^^#^^#^ Spearman correlation

One limitation of Pearson's correlation is that it is detecting linear relationships only. A famous example of this is Anscombe's quartet:

![](https://upload.wikimedia.org/wikipedia/commons/e/ec/Anscombe%27s_quartet_3.svg)

In each pair, the Pearson correlation is an identical .8162! In the first, that's what we want. In the second, the relationship is strong but
non-linear. In the third, only one value is not perfectly correlated, so the Pearsons correlation is diminished. In the fourth, only the existence of
the single outlier is driving the relationship.

Spearman correlation is an alternative to Pearson correlation. It works by ranking each variable and then performing Pearson's correlation. The
command in Stata is `spearman`.

~~~~
<<dd_do>>
corr price trunk
spearman price trunk, matrix
<</dd_do>>
~~~~

The `matrix` option forces output to mirror `correlate`, otherwise it produces a slightly different output when given only two variables. `spearman`
uses [complete cases](#Pairwise-completion-vs-complete-case); to use pairwise complete instead, pass the option `pw`:

~~~~
<<dd_do>>
spearman mpg-headroom, pw
<</dd_do>>
~~~~

How does Spearman's correlation compare to Pearson's for Anscombe's quartet?

| Comparison     | Pearson | Spearman |
|:--------------:|:-------:|:--------:|
| ^$^y_1, x_1^$^ | .8162   | .8182    |
| ^$^y_2, x_2^$^ | .8162   | .6909    |
| ^$^y_3, x_3^$^ | .8162   | .9909    |
| ^$^y_4, x_4^$^ | .8162   | .5000    |

The second correlation diminishes, the third drastically increases, and the fourth decreases as well.

^#^^#^ Exercise 1

For these exercises, we'll be using data from NHANES, the National Health And Nutrition Examination Survey. The data is on Stata's website, and you
can load it via

~~~~
<<dd_do>>
webuse nhanes2, clear
<</dd_do>>
~~~~

1. Use `describe` to get a sense of the data. How many observations? How many variables?
2. Use `tab`, `summarize`, `mean`, and/or `codebook` to get an understanding of the some of variables that we'll be using a lot going forward:
    - `region`
    - `houssiz`
    - `sex`
    - `diabetes`
    - `iron`
3. Does `race` have any missing data? Does `diabetes`? Does `lead`?
4. What is more highly correlated? A person's height and weight, or their diastolic and systolic blood pressure?
