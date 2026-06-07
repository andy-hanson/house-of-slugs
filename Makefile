.PHONY: credits game-backend slugs update-puzzles

SRC_FILES := $(shell find src -type f)

PUZZLES = bin/puzzles-easy bin/puzzles-normal bin/puzzles-hard

all: $(PUZZLES)
	test bin/house-of-slugs.jar index.js

clean:
	rm -r bin

credits:
	$(MAKE) run ARGS=credits
slugs:
	$(MAKE) run ARGS=slugs

check: $(PUZZLES)
	keen check .
test: $(PUZZLES) test-java test-js
test-java:
	keen test .
test-js:
	keen test . --node-js
run: $(PUZZLES)
	@java -Djava.library.path=lib/game-backend/jars/natives --enable-native-access=ALL-UNNAMED -jar $$(which keen) run src -- $(ARGS)
run-debug:
	java -Djava.library.path=lib/game-backend/jars/natives --enable-native-access=ALL-UNNAMED -Dorg.lwjgl.util.Debug=true -jar $$(which keen) run src

bin/house-of-slugs.jar: $(SRC_FILES)
	mkdir -p bin
	keen build src --out bin/house-of-slugs.jar
run-built: $(PUZZLES)
	@java -Djava.library.path=lib/game-backend/jars/natives --enable-native-access=ALL-UNNAMED --sun-misc-unsafe-memory-access=allow -jar house-of-slugs.jar

serve: index.js $(PUZZLES)
	( trap 'kill 0' INT; keen build src --out index.js --watch & keen serve.keen & wait )
index.js: $(SRC_FILES)
	keen build src --out index.js

update-puzzles:
	keen src/puzzles/generate-puzzles.keen
$(PUZZLES):
	$(MAKE) update-puzzles
