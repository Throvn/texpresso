all:
	$(MAKE) texpresso
	$(MAKE) texpresso-xetex
	@echo "# Build succeeded. Try running:"
	@echo "# build/texpresso test/simple.tex"

texpresso:
	$(MAKE) -C src texpresso

dev:
	$(MAKE) -C src texpresso-dev

debug:
	$(MAKE) -C src texpresso-debug texpresso-debug-proxy

clean:
	rm -rf build/objects/*

distclean:
	rm -rf build Makefile.config

re2c:
	$(MAKE) -C src $@

UNAME := $(shell uname)

Makefile.config: Makefile
	$(MAKE) config

ifeq ($(UNAME), Linux)
config:
	mkdir -p build/objects
	echo >Makefile.config "CFLAGS=-O2 -ggdb -I. -fPIC `pkg-config --cflags harfbuzz`"
	echo >>Makefile.config 'CC=gcc $$(CFLAGS)'
	echo >>Makefile.config 'LDCC=g++ $$(CFLAGS)'
	echo >>Makefile.config "LIBS=-lmupdf -lm `CC=gcc ./mupdf-config.sh` -lz -ljpeg -ljbig2dec -lopenjp2 -lgumbo -lSDL2 `pkg-config --libs harfbuzz freetype2`"
endif

ifeq ($(UNAME), Darwin)
BREW=$(shell brew --prefix)
BREW_ICU4C=$(shell brew --prefix icu4c)
config:
	mkdir -p build/objects
	echo >Makefile.config "CFLAGS=-O2 -ggdb -I. -fPIC -I$(BREW)/include `pkg-config --cflags harfbuzz`"
	echo >>Makefile.config 'CC=gcc $$(CFLAGS)'
	echo >>Makefile.config 'LDCC=g++ $$(CFLAGS)'
	echo >>Makefile.config "LIBS=-L$(BREW)/lib -lmupdf -lm `CC=gcc ./mupdf-config.sh -L$(BREW)/lib` -lz -ljpeg -ljbig2dec -lopenjp2 -lSDL2 `pkg-config --libs harfbuzz freetype2`"
endif

texpresso-xetex:
	$(MAKE) -C xetex

compile_commands.json:
	bear -- $(MAKE) -B -k all

.PHONY: all dev clean config texpresso-xetex re2c compile_commands.json
