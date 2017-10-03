^#^ Survey Data

One major strength of Stata is the ease with which it can analyze data sets arising from complex sample surveys. When working with data collected from
a sample with a complex design (anything above and beyond a simple random sample of a population, where the sample design involves clustering and
stratification of sampled elements, and multiple stages of sampling), standard statistical analysis procedures that assume a simple random sample
(such as everything we've discussed so far) will result in very biased estimates of statistics that do no take the design of the sample into
account. Two major problems arise when survey data is analyzed without taking the design into account:

1. Representation
2. Variance Estimation

Incorporation of the weights corrects for biased estimates (representation) and the stratification and clustering produces correct variance estimates.

Stata is one of the leaders in terms of statistical software that can perform these types of analyses, and offers a wide variety of commands that will
perform design-based analyses of data arising from a sample with a complex design. The basic process consists of two steps (similar to
[`mi`](multiple-imputation.html)), first using `svyset` to describe the complex survey design, secondly using the `svy:` prefix to perform analyses.

^#^^#^ Definitions

Complex survey design is a massive topic which there are entire departments devoted to (Program at Survey Methodology here at Michigan) and which we
offer a separate full day workshop (Survey Design). A simple survey design takes a random sample from the population as a whole. There are various
reasons why a simple random sample will not work.

- It is often infeasible to do either because of time or cost.
- With smaller sample sizes, it can be difficult to obtain enough individuals in a given subpopulation.
- For some small subpopulations, it may be very difficult to even obtain any individuals in a simple random sample.

A complex survey design allows researchers to consider these limitations and design a sampling pattern to overcome them. Three primary techniques are

- Stratification. Rather than sample all individuals, instead target specific subpopulations and collect from them explicitly. For example, you may
  stratify by race and aim to collect 50 white, 50 black, 50 Hispanic, etc.
- Clustering. Primarily a cost/time saving measure. Similar to stratification, but instead of sampling from all clusters, you take a random sample of
  clusters and then sample within them. A typical clustering variable is neighborhood or census tract or school.
- Weighting. If certain sets of characteristics are more or less common, or more or less desired, when randomly sampling individuals, we can
  down-weight those who we don't want/are more common, and up-weight those we want/are less common.

For example, we might want to collect data on obesity in school children in Ann Arbor. Rather than randomly sampling across all schools, we cluster by
schools and randomly select 3. Then at each of those schools, we stratify by race and take a random sample of all students of each race at each
school, weighted by their weight to attempt to capture more overweight students.

One final term is *primary sampling unit* which is the first level at which we randomized. In this example, that would be schools.

^#^^#^ Describing the survey

The general syntax is

```
svyset <psu> [pweight = <weight>], strata(<strata>)
```

The `svyset` command defines the variables identifying the complex design of the sample to Stata, and only needs to be submitted once in a given Stata
session. The `<psu>` is a variable identifying the primary sampling unit (PSU) that an observation came from. The <weight> is a variable containing
sampling weights. Finally, the `strata` is a variable identifying the sampling stratum that an observation came from.

The NHANES data we've been using in our examples is actually from a complex sample design, which we've been ignoring. Let's incorporate the sampling
into the analysis.

~~~~
<<dd_do>>
webuse nhanes2, clear
<</dd_do>>
~~~~

The three variables of interest in the data are `finalwgt` for the sampling weights, `strata` for the strata, and `psu` for the clusters.

~~~~
<<dd_do>>
describe finalwgt strata psu
<</dd_do>>
~~~~

It's useful to know that to remove any existing survey design, you can run

~~~~
<<dd_do>>
svyset, clear
<</dd_do>>
~~~~

Let's set up the survey design now.

~~~~
<<dd_do>>
svyset psu [pweight = finalwgt], strata(strata)
<</dd_do>>
~~~~

To get information about the strata and cluster variables use the following command or menu:

~~~~
<<dd_do>>
svydescribe
<</dd_do>>
~~~~

Once the survey is defined with svyset, most common commands can be prefaced by svy: to analyze the data with the sampling structure.  The svy: tab
command works exactly like the tabulate command, only taking the design of the sample into account when producing estimates and chi-square statistics.

~~~~
<<dd_do>>
svy: tab sex
<</dd_do>>
~~~~

Next, lets look at the mean weight by gender.

~~~~
<<dd_do>>
svy: mean weight, over(sex)
<</dd_do>>
~~~~

Compare this to the usual mean command, without the design information:

~~~~
<<dd_do>>
mean weight, over(sex)
<</dd_do>>
~~~~

And compare the `svy:` results to the usual `mean` command, with only the weights considered:

~~~~
<<dd_do>>
mean weight [pweight=finalwgt], over(sex)
<</dd_do>>
~~~~

We see that the weights affect on the standard error, whereas the stratification and clustering also affects the estimates.

As with `mi:`, many of the usual commands such as `regress` or `logit` can be prefaced by `svy:`. If a command errors with the `svy:` prefix, a lot of
the time the survey design will not affect it, and the documentation for the command will inform of that.

^#^^#^ Subset analyses for complex sample survey data

In general, analysis of a particular subset of observations from a sample with a complex design should be handled very carefully. It is usually not
appropriate to delete cases from the data-set that fall outside the sub-population of interest, or to use an if statement to filter them out. In
Stata, sub-population analyses for this type of data are analyzed using a subpop indicator.

Suppose we want to perform an analysis only for the cases where race is black in the NHANES data set. First, we must create an indicator variable
that equals 1 for these cases.

~~~~
<<dd_do>>
gen race_black = race == 2
replace race_black = . if race == .
<</dd_do>>
~~~~

Now we can run a simple regression model only on

~~~~
<<dd_do>>
svy, subpop(race_black): regress weight height i.sex
<</dd_do>>
~~~~

Compare the `svy, subpop( ):` results to the usual `svy: regress` command using an `if` statement:

~~~~
<<dd_do>>
svy: reg weight height i.sex if race_black == 1
<</dd_do>>
~~~~

Stata refuses to even calculate standard errors.
