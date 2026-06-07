.PHONY: credits game-backend slugs update-puzzles

SRC_FILES := $(shell find src -type f)

all: test bin/house-of-slugs.jar site/index.js

credits:
	$(MAKE) run ARGS=credits
slugs:
	$(MAKE) run ARGS=slugs

check:
	keen check src
test: test-java test-js
test-java:
	keen test src
test-js:
	keen test src --node-js
run: bin/puzzles
	@java -Djava.library.path=lib/game-backend/jars/natives --enable-native-access=ALL-UNNAMED -jar $$(which keen) run src -- $(ARGS)
run-debug:
	java -Djava.library.path=lib/game-backend/jars/natives --enable-native-access=ALL-UNNAMED -Dorg.lwjgl.util.Debug=true -jar $$(which keen) run src

bin/house-of-slugs.jar: $(SRC_FILES)
	mkdir -p bin
	keen build src --out bin/house-of-slugs.jar
run-built: bin/puzzles
	@java -Djava.library.path=lib/game-backend/jars/natives --enable-native-access=ALL-UNNAMED --sun-misc-unsafe-memory-access=allow -jar house-of-slugs.jar

serve: site/index.js bin/puzzles
	( trap 'kill 0' INT; keen build src --out site/index.js --watch & keen site/serve.keen & wait )
site/index.js: $(SRC_FILES)
	keen build src --out site/index.js

update-puzzles:
	keen src/game/puzzles/generate-puzzles.keen
bin/puzzles:
	$(MAKE) update-puzzles
