CI := $(if $(CI),yes,no)
SHELL := /bin/bash

ifeq ($(CI), yes)
	POETRY_OPTS = --ansi -v
	PRE_COMMIT_OPTS = --show-diff-on-failure --verbose
endif

PROJECT_NAME := $(shell basename $(PWD))
IMAGE = ghcr.io/finleyfamily/$(PROJECT_NAME)

help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)

attach: ## attach to running container
	@docker container attach --sig-proxy=false

build: permissions ## build docker image
	@docker buildx build . --platform 'linux/amd64,linux/arm64' --pull --tag $(IMAGE):local

fix: run.pre-commit ## run all automatic fixes

fix.md: ## automatically fix markdown format errors
	@poetry run pre-commit run mdformat --all-files

lint: ## run all linters
	@if [ $${CI} ]; then \
		echo ""; \
		echo "skipped linters that have dedicated jobs"; \
	else \
		echo ""; \
		$(MAKE) --no-print-directory lint.docker lint.shellcheck; \
	fi

# for more info: https://github.com/hadolint/hadolint
lint.docker: ## lint Dockerfile
	@echo "Running hadolint..."
	@if [[ $$(command -v hadolint) ]]; then \
		find . -name "*Dockerfile*" -type f | \
			xargs hadolint; \
	else \
		echo "hadolint not installed - install it to lint Dockerfiles"; \
		echo "  - macOS: brew install hadolint"; \
	fi
	@echo ""

lint.shellcheck: ## lint shell scripts using shellcheck
	@echo "Running shellcheck..." && \
	bash ./tests/shellcheck.sh && \
	echo ""

logs: ## retrieve logs from the running container
	@docker container logs --follow --timestamps $(PROJECT_NAME)

permissions: ## set script permissions
	@find ./rootfs/etc/s6-overlay/s6-rc.d -type f \( -name run -or -name finish \) -prune -exec chmod +x {} \;
	@find ./rootfs/usr/bin -type f -prune -exec chmod +x {} \;
	@chmod 777 ./rootfs/tmp

run: stop setup.dirs ## run container with `/init` as the entrypoint to run s6-overlay
	@docker container rm $(PROJECT_NAME) >/dev/null 2>&1 || true;
	@docker container run --detach --rm \
		--name $(PROJECT_NAME) \
		--env "CHEZMOI_REPO=ITProKyle" \
		--volume "$$PWD/tmp/config:/config" \
		--volume "$$PWD/tmp/data:/data" \
		--volume "$$PWD/tmp/defaults:/defaults" \
		--volume "$$PWD/tests:/tests" \
		$(IMAGE):local

run.pre-commit: ## run pre-commit for all files
	@poetry run pre-commit run $(PRE_COMMIT_OPTS) \
		--all-files \
		--color always

setup: setup.poetry setup.pre-commit setup.npm ## setup dev environment

setup.dirs: ## create temp directories for testing locally
	@mkdir -p ./tmp/{app,config,data,defaults};

setup.npm: ## install node dependencies with npm
	@npm ci

setup.poetry: ## setup python virtual environment
	@poetry sync $(POETRY_OPTS)

setup.pre-commit: ## install pre-commit git hooks
	@poetry run pre-commit install

spellcheck: ## run cspell
	@echo "Running cSpell to checking spelling..."
	@npm exec --no -- cspell lint . \
		--color \
		--config .vscode/cspell.json \
		--dot \
		--gitignore \
		--must-find-files \
		--no-progress \
		--relative \
		--show-context

stop: ## stops the container
	@docker container stop $(PROJECT_NAME) >/dev/null 2>&1 || true;

test: ## run tests
	@echo "no tests configured for this project"

zsh: ## connect to container with zsh shell
	@docker exec --interactive --tty $(PROJECT_NAME) /bin/zsh
