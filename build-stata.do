local files 02-summarizing-data 03-visualization 04-univariate-analysis ///
						05-regression 06-mixed-models 07-survey-data 08-multiple-imputation ///
            09-solutions

foreach f in `files' {
	dyndoc stata_markdown/`f'.md, saving("`f'.Rmd") replace nostop
}
