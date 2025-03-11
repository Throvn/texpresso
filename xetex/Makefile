## Target name
XETEX_BIN?=texpresso-xetex.js

## Build configuration
PKG=graphite2 fontconfig icu-uc
CFLAGS = -Iinclude -Ilayout -Idpx -Istatic_libs/include $(_CFLAGS) $(_FLAGS)
LDFLAGS = -lm -lz $(_LDFLAGS) $(_FLAGS) -s WASM=1

# Static linking with custom library paths (missing: ./static_libs/libfontconfig.a (not yet ported by louis))
LDFLAGS += ./static_libs/libgraphite2.a ./static_libs/libicuuc.a ./static_libs/libfreetype.a ./static_libs/libexpat.a

## FOR emscripten:
CFLAGS += -sUSE_ZLIB=1 -sUSE_FREETYPE=1 -sUSE_HARFBUZZ=1 -sUSE_LIBPNG=1
LDFLAGS += -sUSE_ZLIB=1 -sUSE_FREETYPE=1 -sUSE_HARFBUZZ=1 -sUSE_LIBPNG=1 -s USE_ICU=1

# Enable modularization and ES6 export
LDFLAGS += -s MODULARIZE=1 -s EXPORT_ES6=0 -s EXPORT_ALL=1

# Explicitly export the main function
EXPORTED_FUNCTIONS = ['_main']

## Build tools configuration
_FLAGS?=
_CC?=emcc
_CXX?=em++
_LD?=em++
_CFLAGS?=-O2 -g

## Internal variables
DIRS = dpx engine layout main
BUILD_DIRS=../build $(patsubst %,../build/%, $(DIRS))

OBJECTS ?= $(foreach dir,$(DIRS), $(patsubst %.cpp,../build/%.o, $(patsubst %.c,../build/%.o, \
		$(wildcard $(dir)/*.c) \
		$(wildcard $(dir)/*.cpp) \
	)))

## Main targets
all: ../build/$(XETEX_BIN)

clean:
	rm -f $(OBJECTS)

distclean:
	rm -rf ../build

## Internal targets
../build/$(XETEX_BIN): $(OBJECTS)
	$(_LD) $(LDFLAGS) -o $@ $^

../build/%.o: %.c | $(BUILD_DIRS)
	$(_CC) $(CFLAGS) -c -o $@ $^

../build/%.o: %.cpp | $(BUILD_DIRS)
	$(_CXX) $(CXXFLAGS) -c -o $@ $^

$(BUILD_DIRS):
	mkdir -p $@

undefined:
	$(MAKE) all 2>&1 | grep -o 'undefined reference to `.*'"'" | sort -u | cut -d ' ' -f 4

.PHONY: all clean distclean
