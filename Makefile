

# TODO: this suffix is out of our control, and needs to be detected.
OS_SUFFIX=x86-darwin

ML_BUILD = ml-build
ML_BUILD_FLAGS = 

ML_MAKEDEPEND = ml-makedepend
ML_MAKEDEPEND_FLAGS = 

ROOT_SRC = src/
ROOT_BIN = bin/
ROOT_HEAP = $(ROOT_BIN).heap/

PROGRAM_NAME = sml-language-server

PROGRAM = $(ROOT_HEAP)$(PROGRAM_NAME)
HEAP_IMAGE = $(ROOT_HEAP)$(PROGRAM_NAME).$(OS_SUFFIX)

ROOT_CM = $(ROOT_SRC)main/sources.cm
CM_FILES = $(ROOT_CM)

CLEAN_FILES = \
	$(HEAP_IMAGE) \
	.depend


.PHONY:		build
build: $(HEAP_IMAGE) .depend

$(HEAP_IMAGE):
	$(ML_BUILD) $(ML_BUILD_FLAGS) $(ROOT_CM) Main.main $(PROGRAM)
	touch $(HEAP_IMAGE)



.depend:	$(CM_FILES)
	touch .depend
	$(ML_MAKEDEPEND) $(ML_MAKEDEPEND_FLAGS) -n -f .depend $(ROOT_CM) $(HEAP_IMAGE)

# includes the generated *.sml file dependencies
ifneq ($(MAKECMDGOALS),clean)
sinclude .depend
endif


.PHONY:		clean
clean:
	rm -rf `find src -name ".cm" -type d`
	rm -rf `find lib/smlnj -name ".cm" -type d`
	rm -rf .cm
	rm -f $(CLEAN_FILES)
