^#^ Exercise solutions

^#^^#^ Exercise 1

~~~~
<<dd_do>>
webuse nhanes2, clear
<</dd_do>>
~~~~

1)
~~~~
<<dd_do>>
describe, short
<</dd_do>>
~~~~

There are 10,351 observations of 59 variables. The full `describe` output is suppressed for space, but you should run it.

3)
~~~~
<<dd_do>>
tab race, mi
<</dd_do>>
~~~~
No missing data.
~~~~
<<dd_do>>
tab diabetes, mi
<</dd_do>>
~~~~
Two missing values.

`lead` is continuous, so a table isn't the most effective.
~~~~
<<dd_do>>
codebook lead
<</dd_do>>
~~~~
There's a lot of missingness.

4)
~~~~
<<dd_do>>
pwcorr height weight bp*
<</dd_do>>
~~~~
Blood pressure is highly correlated, more-so than height and weight. Weight is also correlated with both forms of BP. Height looks to be completely
independent of boood pressure.

^#^^#^ Exercise 2

~~~~
<<dd_do>>
webuse nhanes2, clear
twoway (scatter bpdiast bpsystol if sex == 1, mcolor(blue)) ///
       (scatter bpdiast bpsystol if sex == 2, mcolor(pink)) ///
       (lfit bpdiast bpsystol if sex == 1, lcolor(blue)) ///
       (lfit bpdiast bpsystol if sex == 2, lcolor(pink)), ///
        legend(label(1 "Men") label(2 "Women") order(1 2))
<</dd_do>>
~~~~

<<dd_graph: replace>>

We can see the correlation between blood pressure measures, with a bit stronger of a relationship for men.

^#^^#^ Exercise 3

~~~~
<<dd_do>>
webuse nhanes2, clear
<</dd_do>>
~~~~

1)

The sample size is massive, so the central limit theorem suffices.

2)

~~~~
<<dd_do>>
ttest height == 176 if sex == 1
<</dd_do>>
~~~~

The test rejects; the average height of men in the sample is lower than the national average.

3)

~~~~
<<dd_do>>
ttest age, by(sex)
<</dd_do>>
~~~~

We fail to reject; there is no difference that the average age differs by gender.

4)

~~~~
<<dd_do>>
tab race diabetes
<</dd_do>>
~~~~

Given the different scales per race, it's hard to draw a comparison. We can look at the rowwise percents. (If you ran `tab diabetes race`, you'd need
the columnwise percents.)

~~~~
<<dd_do>>
tab race diabetes, row chi2
<</dd_do>>
~~~~

Nearly double the percent of blacks have diabetes and the ^$^\chi^2^$^ test confirms the difference is statistically significant.

^#^^#^ Exercise 4

~~~~
<<dd_do>>
webuse nhanes2, clear
regress lead i.sex i.race c.age c.weight c.height i.region
<</dd_do>>
~~~~

1)

The F-test rejects so the model is informative. The ^$^R^2^$^ is low, so there is a lot of variability we're not capturing in this model.

2)

~~~~
<<dd_do>>
rvfplot
<</dd_do>>
~~~~

<<dd_graph: replace>>

This doesn't look great. We don't see any signs of nonnormality, but we do see a lot of very large positive residuals. If you look at a histogram for
`lead`,

~~~~
<<dd_do>>
hist lead
<</dd_do>>
~~~~

<<dd_graph: replace>>

We see right skew. The maintainers of this data noticed the same concern, as they include a `loglead` variable in the data to attempt to address this.

~~~~
<<dd_do>>
desc loglead
<</dd_do>>
~~~~

Perhaps we should have run the model with `loglead` as the output instead.

3)

~~~~
<<dd_do>>
estat vif
<</dd_do>>
~~~~

Nothing of concern here. The only moderately high VIF's are on sex and it's interaction, which does not concern us (of course a main effect and
interaction are collinear.).

4)

The coffecient on "Female" is -5 and is statistically significant, so there is evidence that males have higher average lead levels.

5)

The p-value is very small, so it is statistically significant. However, if we look at lead levels:

~~~~
<<dd_do>>
summ lead
<</dd_do>>
~~~~

We see that lead levels range from 2 to 80. The coefficient on age is about .02, so age would need to increase by about 50 years to see a higher value
for the lead score. Unlikely to be clinically interesting! This is a side effect of the massive sample size.

6)

~~~~
<<dd_do>>
margins region
margins region, pwcompare(pv)
<</dd_do>>
~~~~

It looks like South is significantly lower levels of lead than the other regions, which show no difference between them.

7)

~~~~
<<dd_do>>
regress lead i.sex##c.age i.race c.weight c.height i.region
margins sex, dydx(age)
quietly margins sex, at(age = (20 45 70))
marginsplot
<</dd_do>>
~~~~

<<dd_graph: replace>>

We see significance in the interaction, so we looked at the margins. It looks like men show a slight decline in lead as age increases (again,
rescaling, -.015/year becomes -1.5 over 100 years - not very interesting) while women show a much more significant increase as age increases (roughly
1 unit every 20 years). The marginal plot helps us to visualize this. For men, from age 20 to 70, the average lead decreases barely half a point. For
women, we see nearly a 3 point average increase.


^#^^#^ Exercise 5

~~~~
<<dd_do>>
webuse nhanes2, clear
logit diabetes i.sex i.race c.age weight height i.region
<</dd_do>>
~~~~

1)

~~~~
<<dd_do>>
estat gof
estat gof, group(20)
lroc
<</dd_do>>
~~~~

<<dd_graph: replace>>

We cannot reject the model fit (even once we switch to the proper Hosmer-Lemeshow test, which used 20 instead of 10 because we have 10 predictors). The ROC and AUC look decent but not great.

2)

~~~~
<<dd_do>>
margins race, pwcompare(pv)
margins region, pwcompare(pv)
<</dd_do>>
~~~~

Blacks are more likely to have diabetes than whites or others. Age and weight are positive predictors whereas height is a negative predictor for some
reason. There is no effect of gender or region.

^#^^#^ Exercise 6

~~~~
<<dd_do>>
webuse chicken, clear
melogit complain grade i.race i.gender tenure age income ///
    nworkers i.genderm || restaurant:
<</dd_do>>
~~~~

1)

We can't look at fit statistics, but the ^$^\chi^2^$^ is significant, so we're doing better than chance.

2)

~~~~
<<dd_do>>
margins race, pwcompare(pv)
<</dd_do>>
~~~~

Unfortunately, this data is poorly labeled so we can't talk in specifics about things, but generally

- Race 1, 2 and 3 have increasing odds of a complaint.
- Gender 1 has significantly higher odds than gender 2.
- Age and income are negatively related to the odds of a complaint (older, more well paid employees are less likely to have complaints).
- Neither restaurant level characteristic is significant once server characteristics are accounted for.

3)

The estimated random variance is non-zero, so yes, the random effects for restaurants are warranted.
