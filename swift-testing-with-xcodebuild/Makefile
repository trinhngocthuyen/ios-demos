DERIVED_DATA := DerivedData

ensure.cicd:
	which cicd &> /dev/null || pip install -U seeeye

build: ensure.cicd
	cicd ios build \
		--derived-data-path $(DERIVED_DATA) \
		--build-for-testing

test: ensure.cicd
	cicd ios test \
	  --test-without-building \
		--derived-data-path $(DERIVED_DATA) \
		--only-testing EXTests/NewTestCase/foo \
		--only-testing EXTests/freeTest \
		--only-testing '"EXTests/NewTestCase/parameterizedExample(x:)"'
