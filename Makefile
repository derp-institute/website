# For your convenience, the following Debian packages are required:
# node-less node-uglify optipng inkscape python-mako imagemagick

BUILD_DIR=build

ART := $(shell find art/*.svg)
ART_RENDERS := $(addprefix $(BUILD_DIR)/static/,$(ART:art/%.svg=%.png))
FELLOWS := $(notdir $(shell find art/fellows/))
FELLOWS_RENDERS := $(addprefix $(BUILD_DIR)/static/fellows/,$(FELLOWS:%.png=%.jpg))
FELLOWS_CONVERT := convert -set colorspace RGB -colorspace gray -normalize -resize "223x" -gravity center -crop "223x168+0+0" -set page "223x168+0+0" -background white -flatten -unsharp 1x2
COMMUNITIES := $(notdir $(shell find art/communities/))
COMMUNITIES_RENDERS := $(addprefix $(BUILD_DIR)/static/communities/,$(COMMUNITIES))
COMMUNITIES_CONVERT := convert -colorspace RGB -resize "x50" -channel RGBA -unsharp 1x1

all: $(BUILD_DIR) $(BUILD_DIR)/static $(ART_RENDERS) $(FELLOWS_RENDERS) $(COMMUNITIES_RENDERS) $(BUILD_DIR)/static/main.css $(BUILD_DIR)/index.html $(BUILD_DIR)/error.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: $(BUILD_DIR)/static
$(BUILD_DIR)/static:
	cp -ruTL src/static $@
	mkdir -p $(BUILD_DIR)/static/fellows
	mkdir -p $(BUILD_DIR)/static/communities

$(BUILD_DIR)/static/%.png: art/%.svg
	inkscape -d 180 -e $@ $<
	optipng -o5 $@

$(BUILD_DIR)/static/fellows/%.jpg: art/fellows/%.png
	$(FELLOWS_CONVERT) $< $@

$(BUILD_DIR)/static/communities/%.png: art/communities/%.png
	$(COMMUNITIES_CONVERT) $< $@

$(BUILD_DIR)/static/main.css: src/main.less
	lessc -x $< > $@

$(BUILD_DIR)/%.html: render.py src/data.json src/%.html
	./render.py src/data.json $*.html > $@

clean:
	rm -rf $(BUILD_DIR)
