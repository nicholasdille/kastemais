GIT_COMMIT = $(shell git rev-list -1 HEAD)
BUILD_TIME = $(shell date +%Y%m%d%H%M%S)
GIT_TAG = $(shell git describe --tags 2>/dev/null)
ifeq ($(strip $(GIT_TAG)),)
GIT_TAG = $(GIT_COMMIT)
endif

.PHONY:
debug:
	@echo "GIT_COMMIT=$(GIT_COMMIT)."; \
	echo "BUILD_TIME=$(BUILD_TIME)."; \
	echo "GIT_TAG=$(GIT_TAG)."

.PHONY:
prepare:
	@docker build --tag nicholasdille/kastemais:$(GIT_TAG) .

.PHONY:
app-%: prepare
	@source functions.sh; \
	merge_app $*
