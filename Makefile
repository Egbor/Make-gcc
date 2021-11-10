CC = gcc

SRCDIR = src/
INCDIR = include/
OUTDIR = bin/
LIBDIR = lib/
OBJDIR = obj/

RPATH = -Wl,-rpath=$(LIBDIR)
INCLUDES = -I$(INCDIR)
LIBRERIES = -L$(OUTDIR)$(LIBDIR)

HELLODIR = hello/
LIBHELLODIR = libhello/
LIBGOODBYEDIR = libgoodbye/

HELLOOBJDIR = $(SRCDIR)$(HELLODIR)$(OBJDIR)
LIBHELLOOBJDIR = $(SRCDIR)$(LIBHELLODIR)$(OBJDIR)
LIBGOODBYEOBJDIR = $(SRCDIR)$(LIBGOODBYEDIR)$(OBJDIR)

HELLOSRC = $(wildcard $(SRCDIR)$(HELLODIR)*.c)
LIBHELLOSRC = $(wildcard $(SRCDIR)$(LIBHELLODIR)*.c)
LIBGOODBYESRC = $(wildcard $(SRCDIR)$(LIBGOODBYEDIR)*.c)

TARGETOUTPUT = $(OUTDIR)
TARGETLIBOUTPUT = $(OUTDIR)$(LIBDIR)lib

TARGETHELLO = hello
TARGETLIBHELLO = hello
TARGETLIBGOODBYE = goodbye

all: dirs $(patsubst %.c,%.o,$(HELLOSRC)) libs
	$(CC) $(INCLUDES) $(LIBRERIES) $(RPATH) -o $(TARGETOUTPUT)$(TARGETHELLO).out $(HELLOOBJDIR)*.o -l$(TARGETLIBHELLO) -l$(TARGETLIBGOODBYE)

libs:  $(patsubst %.c,%.o,$(LIBGOODBYESRC)) $(patsubst %.c,%d.o,$(LIBHELLOSRC))
	$(CC) -shared -o $(TARGETLIBOUTPUT)$(TARGETLIBHELLO).so $(LIBHELLOOBJDIR)*.o
	ar rc $(TARGETLIBOUTPUT)$(TARGETLIBGOODBYE).a $(LIBGOODBYEOBJDIR)*.o
	ranlib $(TARGETLIBOUTPUT)$(TARGETLIBGOODBYE).a

clean:
	rm -r -f $(OUTDIR)
	rm -r -f $(HELLOOBJDIR)
	rm -r -f $(LIBHELLOOBJDIR)
	rm -r -f $(LIBGOODBYEOBJDIR)

dirs:
	mkdir -p $(OUTDIR)$(LIBDIR)
	mkdir -p $(HELLOOBJDIR)
	mkdir -p $(LIBHELLOOBJDIR)
	mkdir -p $(LIBGOODBYEOBJDIR)

%.o: %.c
	$(CC) $(INCLUDES) -c -MD $< -o $(@D)/$(OBJDIR)$(@F)
%d.o: %.c
	$(CC) -fPIC -c -MD $< -o $(@D)/$(OBJDIR)$(@F)
 
include $(wildcard $(HELLOOBJDIR)*.d)
include $(wildcard $(LIBHELLOOBJDIR)*.d)
include $(wildcard $(LIBGOODBYEOBJDIR)*.d)
