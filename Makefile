ONESHELL:
ENV_PREFIX=$(shell python -c "if __import__('pathlib').Path('.venv/bin/pip').exists(): print('.venv/bin/')")

.PHONY: help
help:             ## Show the help.
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@fgrep "##" Makefile | fgrep -v fgrep



.PHONY: lint
reformat:             ## Run pep8, black, mypy linters.
	$(ENV_PREFIX)black  --pyi -l 79 -t py311 src/
	$(ENV_PREFIX)black  --pyi -l 79 -t py311 tests/
	$(ENV_PREFIX)black  --ipynb -l 79 -t py311 lab/

lint:             ## Run pep8, black, mypy linters.
	$(ENV_PREFIX)flake8 src/
	$(ENV_PREFIX)black -l 79 -t py311 --check src/
	$(ENV_PREFIX)black -l 79 -t py311 --check tests/
	$(ENV_PREFIX)black -l 79 -t py311 --check lab/
	$(ENV_PREFIX)mypy --ignore-missing-imports src/

.PHONY: test
test: lint        ## Run tests and generate coverage report.
	$(ENV_PREFIX)coverage run -m pytest -v  -l --tb=short --maxfail=1 tests/
	$(ENV_PREFIX)coverage xml
	$(ENV_PREFIX)coverage html 

