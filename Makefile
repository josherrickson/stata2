dyndocs = 01-summarizing-data.qmd 02-visualization.qmd \
					03-univariate-analysis.qmd 04-regression.qmd \
					05-mixed-models.qmd 06-survey-data.qmd \
					07-multiple-imputation.qmd solutions.qmd


.PHONY:default
default: $(dyndocs)
	quarto render

.PHONY:quarto-prerender
quarto-prerender: $(dyndocs)
	@echo > /dev/null

$(dyndocs): %.qmd: %.dyndoc
	/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyntext "$<", saving("$@") replace nostop'

.PHONY:open
open:
	@open docs/index.html

.PHONY: check-valid-public-site
check-valid-public-site:
	@if [ ! -d "../public-site" ]; then \
		echo "../public-site does not exist."; \
		exit 1; \
	fi
	@if [ ! -d "../public-site/.git" ]; then \
		echo "../public-site is not a Git repository."; \
		exit 1; \
	fi

.PHONY: publicize
publicize: check-valid-public-site
	@echo Syncing to ../public-site/public
	@mkdir -p ../public-site/public/stata2
	@rsync -rv docs/ ../public-site/public/stata2
