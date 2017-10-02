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
