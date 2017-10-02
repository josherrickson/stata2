^#^ Exercise solutions

^#^^#^ Exercise 1

1)
~~~~
<<dd_do>>
describe
<</dd_do>>
~~~~

There are 10,351 observations of 59 variables.

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
Lot's of missingness.

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
twoway (scatter bpdiast systol if sex == 1, mcolor(blue)) ///
       (scatter bpdiast systol if sex == 2, mcolor(pink)) ///
       (lfit bpdiast systol if sex == 1, lcolor(blue)) ///
       (lfit bpdiast systol if sex == 2, lcolor(pink)), ///
        legend(label(1 "Men") label(2 "Women"))
<</dd_do>>
~~~~

^#^^#^ Exercise 3

1) The sample size is massive, so the central limit theorem suffices.

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
We fail to reject; there is no idfference that the average height differs by gender.

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
