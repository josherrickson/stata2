^#^ Univariate (and some Bivariate) Analysis

We start with analyzing single variables at a time, and then quickly discuss a chi-squared test which is a bivariate analysis. While these tests form
the basis of many other methods, by themselves they are of limited us. All the tests we discuss here come with two very strong assumptions:

1. No other measured or unmeasured variables play a role in any relationship.
2. The relationship is the same for any subpopulation of your data.

To see why these assumptions are so strong, lets consider the [two-sample t-test](#two-sample-t-test). We'll discuss them in depth below, but the
short version is that a two-sample t-test compares whether two groups have the same average value. If you were comparing average height between two
groups, perhaps you'd find that one group was much taller than the other. But what if the shorter group was almost entirely made of children? We have
no way of knowing whether the difference between groups is due to this or due to real differences.

For the second assumption, imagine some scenario where you have two groups. Among men, there is a large difference between groups, whereas among
women, there is no difference between groups. On average (assuming a roughly 50/50 gender split), you'd see a moderate difference. But no one actually
has a moderate difference! The two subgroups have different effects, so the two-sample t-test captures neither!

That said, there are a few situations where these tests are useful as stand-alone tests.

1. Exploratory/descriptive/pilot studies: Situations when are you not making strong claims, merely describing something you see in the data.
2. Very small sample sizes: While not ideal, small sample sizes can't handle more complicated analysis, so these simple ones are all you have.
3. In randomized controlled experiments (such as in a lab): In these situations, you truly can ensure that both those assumptions are met. Just
   randomization is not sufficient, as the benefit of randomization is only guaranteed *theoretically* for *infinitely large samples*. Randomization
   helps a lot, but it's not perfect!

^#^^#^ One-sample t-test

A one-sample t-test tests whether the mean of a variable is equal to some constant. It is not needed a lot of the time (if we hypothesize that the
average test score is 70, and every students getabove an 80, why would we need to test this?), but we introduce it here just as a basis of further
methods.

There are several assumptions necessary for a one-sample t-test, most of which are trivial/not that important. The two relatively important ones are

1. Independence. Each value must come from an independent source. If you have repeated measures (e.g. two different measures for the same person),
   this is violated. See the section of [mixed models](mixed-models.html) for dealing with this sort of data.
2. The distribution of the *mean* is normal. Note that this assumption is *not* about the data itself. This assumption is valid if *either* the sample
   suggests that the data is normal (a bell-curve) *or* the sample size is large (above ~30)^[This is by
   the [central limit theorem](https://en.wikipedia.org/wiki/Central_limit_theorem)]. If this assumption does not hold, we generally still use the
   t-test, although there are tests called "non-parametric" tests which do not require this assumption. Not everyone is convinced they are necessary.



^#^^#^ Two-sample t-test

^#^^#^^#^ Paired

^#^^#^^#^ Independent

^#^^#^ Chi-square test
