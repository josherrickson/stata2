local files 01-summarizing-data 02-visualization 03-univariate-analysis ///
						04-regression 05-mixed-models 06-multiple-imputation 07-survey-data

foreach f in `files' {
	dyndoc stata_markdown/`f'.md, saving("`f'.Rmd") replace nostop
}
