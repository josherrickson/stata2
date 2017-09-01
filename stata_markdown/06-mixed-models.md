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

^#^^#^ Linear Mixed Model

The most basic mixed model is the linear mixed model, which extends the [linear regression](#linear-regression) model.

^#^^#^ Logistic Mixed Model
