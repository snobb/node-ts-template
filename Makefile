BIN := ./node_modules/.bin
TS_FILES := $(shell find src/ -name '*.ts')
TEST_FILES := src/**/*.test.ts
MOCHA_OPTS := --bail --type-check --full-trace

all: dist

## help:		show this help
.PHONY: help
help:
	@sed -n 's/^##//p' makefile

## test:		run unit tests (if FILE env variable specified - run test for that file)
.PHONY: test
ifdef FILE
test: dist
	$(BIN)/c8 --reporter=none $(BIN)/mocha --require @swc-node/register ${MOCHA_OPTS} $(FILE)
else
test: dist
	$(BIN)/c8 --reporter=none \
		$(BIN)/mocha --require @swc-node/register ${MOCHA_OPTS} ${TEST_FILES} && \
		$(BIN)/c8 report --all --clean -n src -x ${TEST_FILES} -x 'src/types.*' --reporter=text
endif

## clean: 	clean the project
.PHONY: clean
clean:
	rm -rf coverage dist node_modules package-lock.json

dist: node_modules $(TS_FILES) tsconfig.json
	rm -rf dist
	$(BIN)/tsc -p tsconfig-build.json

node_modules: package.json package-lock.json
	npm install || (rm -rf $@; exit 1)
	test -d $@ && touch $@ ||:

package-lock.json:
	npm install
