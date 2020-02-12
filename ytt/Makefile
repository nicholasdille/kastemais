APP_DIR=app
OVERLAY_DIR=overlay
APPS:=$(wildcard $(APP_DIR)/*)
OVERLAYS:=$(wildcard $(OVERLAY_DIR)/*)
APP_TEST_RESULTS:=$(addsuffix /result.txt,$(addprefix test/,$(APPS)))
OVERLAY_TEST_RESULTS:=$(sort $(addsuffix /result.txt,$(addprefix test/,$(OVERLAYS))))

.PHONY:
debug:
	@echo APP_DIR=$(APP_DIR) OVERLAY_DIR=$(OVERLAY_DIR); \
	echo APPS=$(APPS); \
	echo OVERLAYS=$(OVERLAYS); \
	echo APP_TEST_RESULTS=$(APP_TEST_RESULTS); \
	echo OVERLAY_TEST_RESULTS=$(OVERLAY_TEST_RESULTS)

.PHONY:
test: $(OVERLAY_TEST_RESULTS)

.PHONY:
clean:
	@find . -type f -name result.txt -exec rm {} \;

%/result.txt:
	@test -f $*/test.yaml; \
	ytt -f $*/test.yaml -f $(*:test/%=%) >$*/result.txt; \
	diff -u $@ $*/result.txt