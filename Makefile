BIN := ./node_modules/.bin
TS_FILES := ${shell find src/ -name '*.ts'}
TEST_FILES := ${shell find src/ -name '*.test.ts'}

all: dist

## help:		show this help
.PHONY: help
help:
	@sed -n 's/^##//p' Makefile

## run:		run the program
run: dist
	node --enable-source-maps ./dist/app.js

## lint:		run linter checks
.PHONY: lint
lint: node_modules
	$(BIN)/biome check --write --error-on-warnings

## format:	run formatter checks
.PHONY: format
format: node_modules
	$(BIN)/biome format --write

## test:		run tests
.PHONY: test
test: node_modules dist
	node --experimental-vm-modules ./node_modules/.bin/jest --coverage

## test-watch:	watch files and related tests
## 		set FILE to limit to specific spec
.PHONY: test-watch
test-watch: node_modules dist
	node --experimental-vm-modules ./node_modules/.bin/jest --watchAll ${FILE}

.PHONY: clean-dist
clean-dist:
	-rm -rf dist

## clean: 	clean the project
.PHONY: clean
clean: clean-dist
	-rm -rf coverage node_modules package-lock.json

## dist:		build the project
.PHONY: dist
dist: clean-dist node_modules $(TS_FILES) tsconfig.json package.json
	$(BIN)/tsc -p tsconfig-build.json || rm -rf dist

.PHONY: node_modules
node_modules: package-lock.json
	npm install || (rm -rf node_modules; exit 1)
	test -d $@ && touch $@ ||:

package-lock.json:
	npm install
