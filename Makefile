export LC_ALL := en_US.UTF-8

PYTHON ?= python3

test:
	docker run -i -t --rm \
		--volume .:/root/.vim/bundle/taskwiki:ro \
		--env COVERALLS_PARALLEL \
		--env GITHUB_ACTIONS \
		--env GITHUB_HEAD_REF \
		--env GITHUB_REF \
		--env GITHUB_RUN_ID \
		--env GITHUB_RUN_NUMBER \
		--env GITHUB_SHA \
		--env GITHUB_TOKEN \
		--env PYTEST_FLAGS="-o cache_dir=/tmp/pytest-cache $(PYTEST_FLAGS)" \
		taskwiki_tests \
		make xvfb-cover-pytest

pytest:
	$(PYTHON) -m pytest -vv $(PYTEST_FLAGS) tests/

cover-pytest: PYTEST_FLAGS += --cov=taskwiki
cover-pytest: pytest
	if [ "$$GITHUB_ACTIONS" ]; then coveralls || :; fi

xvfb-%:
	xvfb-run --server-args=-noreset $(MAKE) $*
