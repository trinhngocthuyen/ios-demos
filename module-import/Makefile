default: modules.build

FORMATTER = tee
ifneq ($(shell which xcbeautify),)
	FORMATTER = xcbeautify
else ifneq ($(shell gem info xcpretty),)
	FORMATTER = bundle exec xcpretty
else ifneq ($(shell which xcpretty),)
	FORMATTER = xcpretty
endif

modules.build:
	cd modules && make all

build: modules.build
	xcodebuild -scheme EX | $(FORMATTER)
