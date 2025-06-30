SUFFIXES = .c .mod .def .o .obj .lo .a .i
DEPFLAGS=-MMD -MT $@ -MP -MF .deps/$*.d

SHELL=/bin/bash

prefix= @prefix@
datarootdir= @datarootdir@
srcdir= @srcdir@
mandir= @mandir@
exec_prefix=@exec_prefix@
bindir= @bindir@
INSTALL_PROGRAM = install

PYTHON_VERSION=$(strip $(shell python3 -V 2>&1 | cut -b8- | cut -f1-2 -d'.'))

noinst_LTLIBRARIES = libfractapi.la

libfractapi_la_SOURCES = Fractions.mod fractapi.mod GC.mod

M2_DEPS = Fractions.lo fractapi.lo GC.lo

GM2_LIB_DIR=$(shell gm2 -print-file-name=)
# GCC_DEFAULT_LIB=/opt/gm2/lib      # for arm
GCC_DEFAULT_LIB=$(HOME)/opt/lib64

SRC_PATH_PIM=-I$(srcdir)/pge-m2 -fm2-pathname=m2pim -I$(GM2_LIB_DIR)/m2/m2pim \
             -fm2-pathname=m2iso -I$(GM2_LIB_DIR)/m2/m2iso -fno-m2-pathname=-

PROFILE =
CHECK = -fsoft-check-all
# CHECK =
OPT = -O0

GM2FLAGS = $(OPT) $(PROFILE) $(CHECK) -g -fm2-g -fiso -fextended-opaque \
           -I$(srcdir)/src-m2 -g

_fractapi.so: fractapi.lo
	cp fractapi.lo _fractapi.so

fractapi.lo: fractapi.mod
	$(LIBTOOL) --tag=CC $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) \
               --mode=compile gm2 -c $(CFLAGS_FOR_TARGET) $(LIBCFLAGS) \
               $(libgm2_la_M2FLAGS) $(CHECK) -g -fm2-g -fno-m2-pathname=- \
               -I$(srcdir) $(SRC_PATH_PIM) \
               -fruntime-modules=- \
               -fgen-module-list=fractapi.lst -fscaffold-main \
               -fscaffold-static -fshared \
               $(srcdir)/fractapi.mod -o $@
	cat fractapi.lst

libfractapi.la: $(M2_DEPS)
	gm2 -fswig -c -I$(srcdir) $(srcdir)/fractapi.mod
	swig -outdir . -o fractapi_wrap.cxx -c++ -python fractapi.i
	$(LIBTOOL) --tag=CC --mode=compile g++ -g -c fractapi_wrap.cxx \
                   -I/usr/include/python$(PYTHON_VERSION) $(CFLAGS_FOR_TARGET) \
                   -o fractapi_wrap.lo
	$(LIBTOOL) --tag=CC --mode=link gcc -g $(M2_DEPS) fractapi_wrap.lo \
           -L$(GCC_DEFAULT_LIB) \
           -rpath `pwd` -lm2iso -lm2pim -lgcc -lstdc++ -lc -lm -o libfractapi.la
	cp .libs/libfractapi.so _fractapi.so

%.lo: %.mod .deps/%.d
	@test -z .deps || mkdir -p .deps
	$(LIBTOOL) --tag=CC $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=compile \
        gm2 -g -fm2-g -fiso $(DEPFLAGS) $(OPT) $(CHECK) \
        -fextended-opaque -I. -I$(srcdir) -c $< -o $@

.c.lo:
	$(LIBTOOL) --tag=CC $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=compile \
        gcc -c $(DEPFLAGS) $(CFLAGS_FOR_TARGET) $(LIBCFLAGS) \
        $(libgm2_la_M2FLAGS) $< -o $@

DEPFILES=$(libfractapi_la_SOURCES:%.mod=.deps/%.d)

$(DEPFILES):

include $(wildcard $(DEPFILES))
