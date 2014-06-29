# For your convenience, the following Debian packages are required:
# node-less node-uglify optipng inkscape python-mako

BUILD_DIR=build

ART := $(shell find art/*.svg)
ART_RENDERS := $(addprefix $(BUILD_DIR)/static/,$(ART:art/%.svg=%.png))

all: $(BUILD_DIR) $(BUILD_DIR)/static $(ART_RENDERS) $(BUILD_DIR)/static/main.css $(BUILD_DIR)/index.html $(BUILD_DIR)/error.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: $(BUILD_DIR)/static
$(BUILD_DIR)/static:
	cp -ruTL src/static $@

$(BUILD_DIR)/static/%.png: art/%.svg
	inkscape -d 180 -e $@ $<
	optipng -o5 $@

$(BUILD_DIR)/static/main.css: src/main.less
	lessc -x $< > $@

$(BUILD_DIR)/%.html: render.py src/data.json src/%.html
	./render.py src/data.json $*.html > $@

clean:
	rm -rf $(BUILD_DIR)
