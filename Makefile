

ML_BUILD = ml-build
ML_BUILD_FLAGS = 

ROOT_SRC = src/

PROGRAM = sml-language-server
HEAP_IMAGE = $(PROGRAM).img
ROOT_CM = $(ROOT_SRC)main/sources.cm


$(HEAP_IMAGE):
	$(ML_BUILD) $(ML_BUILD_FLAGS) $(ROOT_CM) Main.main $(PROGRAM)
	touch $(HEAP_IMAGE)
