
SHELL = /bin/sh

# V=0 quiet, V=1 verbose.  other values don't work.
V = 0
Q1 = $(V:1=)
Q = $(Q1:0=@)
n=$(NULLCMD)
ECHO1 = $(V:1=@$n)
ECHO = $(ECHO1:0=@echo)

#### Start of system configuration section. ####

srcdir = .
topdir = /usr/include/ruby-1.9.1
hdrdir = /usr/include/ruby-1.9.1
arch_hdrdir = /usr/include/ruby-1.9.1/$(arch)
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
prefix = $(DESTDIR)/usr
rubylibprefix = $(libdir)/$(RUBY_BASE_NAME)
exec_prefix = $(prefix)
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(includedir)/$(RUBY_BASE_NAME)-$(ruby_version)
vendordir = $(rubylibprefix)/vendor_ruby
sitedir = $(rubylibprefix)/site_ruby
ridir = $(datarootdir)/$(RI_BASE_NAME)
mandir = $(datarootdir)/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(datarootdir)/info
docdir = $(datarootdir)/doc/$(PACKAGE)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
localstatedir = $(prefix)/var
sharedstatedir = $(prefix)/com
sysconfdir = $(DESTDIR)/etc
datadir = $(datarootdir)
datarootdir = $(prefix)/share
libexecdir = $(exec_prefix)/libexec
sbindir = $(exec_prefix)/sbin
bindir = $(exec_prefix)/bin
rubylibdir = $(rubylibprefix)/$(ruby_version)
archdir = $(rubylibdir)/$(arch)
sitelibdir = $(sitedir)/$(ruby_version)
sitearchdir = $(sitelibdir)/$(sitearch)
vendorlibdir = $(vendordir)/$(ruby_version)
vendorarchdir = $(vendorlibdir)/$(sitearch)

NULLCMD = :

CC = gcc
CXX = g++
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static
OUTFLAG = -o 
COUTFLAG = -o 

RUBY_EXTCONF_H = 
cflags   =  $(optflags) $(debugflags) $(warnflags)
optflags = -O3
debugflags = -ggdb
warnflags = -Wextra -Wno-unused-parameter -Wno-parentheses -Wno-long-long -Wno-missing-field-initializers -Wpointer-arith -Wwrite-strings -Wdeclaration-after-statement -Wimplicit-function-declaration
CFLAGS   = -fPIC -march=x86-64 -mtune=generic -O2 -pipe -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2 -fPIC -I/usr/include/SDL -D_GNU_SOURCE=1 -D_REENTRANT -D ENABLE_M17N  -D ENABLE_OPENGL  $(ARCH_FLAG)
INCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir)/ruby/backward -I$(hdrdir) -I$(srcdir)
DEFS     = 
CPPFLAGS = -DHAVE_RB_THREAD_BLOCKING_REGION -DHAVE_RB_ENC_STR_NEW -DHAVE_RB_STR_EXPORT_TO_ENC -I/usr/X11R6/include  $(DEFS) $(cppflags)
CXXFLAGS = $(CFLAGS) -march=x86-64 -mtune=generic -O2 -pipe -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2
ldflags  = -L. -Wl,-O1,--sort-common,--as-needed,-z,relro,--hash-style=gnu -rdynamic -Wl,-export-dynamic
dldflags = 
ARCH_FLAG = 
DLDFLAGS = $(ldflags) $(dldflags) $(ARCH_FLAG)
LDSHARED = $(CC) -shared
LDSHAREDXX = $(CXX) -shared
AR = ar
EXEEXT = 

RUBY_BASE_NAME = ruby
RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = ruby
arch = x86_64-linux
sitearch = $(arch)
ruby_version = 1.9.1
ruby = /usr/bin/ruby
RUBY = $(ruby)
RM = rm -f
RM_RF = $(RUBY) -run -e rm -- -rf
RMDIRS = rmdir --ignore-fail-on-non-empty -p
MAKEDIRS = /bin/mkdir -p
INSTALL = /bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp

#### End of system configuration section. ####

preload = 

libpath = . $(libdir) /usr/X11R6/lib
LIBPATH =  -L. -L$(libdir) -L/usr/X11R6/lib
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS =  -L/usr/lib -lSDL -lpthread
LIBS = $(LIBRUBYARG_SHARED) -lGL  -lpthread -lrt -ldl -lcrypt -lm   -lc
SRCS = rubysdl_time.c rubysdl_video.c rubysdl_mixer.c rubysdl_main.c rubysdl_opengl.c SDL_kanji.c rubysdl_smpeg.c rubysdl_rwops.c rubysdl_sdlskk.c rubysdl_cdrom.c rubysdl_event_key.c rubysdl_wm.c rubysdl_image.c rubysdl_sge_video.c rubysdl_event.c rubysdl_kanji.c rubysdl_joystick.c rubysdl_ttf.c rubysdl_pixel.c rubysdl_mouse.c
OBJS = rubysdl_time.o rubysdl_video.o rubysdl_mixer.o rubysdl_main.o rubysdl_opengl.o SDL_kanji.o rubysdl_smpeg.o rubysdl_rwops.o rubysdl_sdlskk.o rubysdl_cdrom.o rubysdl_event_key.o rubysdl_wm.o rubysdl_image.o rubysdl_sge_video.o rubysdl_event.o rubysdl_kanji.o rubysdl_joystick.o rubysdl_ttf.o rubysdl_pixel.o rubysdl_mouse.o
TARGET = sdl_ext
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR = /home/rio/.gem/ruby/1.9.1/gems/rubysdl-2.1.1/lib$(target_prefix)
RUBYARCHDIR = /home/rio/.gem/ruby/1.9.1/gems/rubysdl-2.1.1/lib$(target_prefix)
HDRDIR        = $(rubyhdrdir)/ruby$(target_prefix)
ARCHHDRDIR    = $(rubyhdrdir)/$(arch)/ruby$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).so 
CLEANOBJS     = *.o  *.bak

all:    $(DLLIB)
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-rb

clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-rb-default clean-rb
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean-rb-default::
distclean-rb::
distclean-so::
distclean: clean distclean-so distclean-rb-default distclean-rb
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		@-$(RMDIRS) $(DISTCLEANDIRS) 2> /dev/null || true

realclean: distclean
install: install-so install-rb

install-so: $(RUBYARCHDIR)
install-so: $(RUBYARCHDIR)/$(DLLIB)
$(RUBYARCHDIR)/$(DLLIB): $(DLLIB)
	@-$(MAKEDIRS) $(@D)
	$(INSTALL_PROG) $(DLLIB) $(@D)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
pre-install-rb-default: $(RUBYLIBDIR)
install-rb-default: $(RUBYLIBDIR)/rubysdl_compatible_ver1.rb $(RUBYLIBDIR)
$(RUBYLIBDIR)/rubysdl_compatible_ver1.rb: $(srcdir)/lib/rubysdl_compatible_ver1.rb
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/rubysdl_compatible_ver1.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/rubysdl_aliases.rb $(RUBYLIBDIR)
$(RUBYLIBDIR)/rubysdl_aliases.rb: $(srcdir)/lib/rubysdl_aliases.rb
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/rubysdl_aliases.rb $(@D)
install-rb-default: $(RUBYLIBDIR)/sdl.rb $(RUBYLIBDIR)
$(RUBYLIBDIR)/sdl.rb: $(srcdir)/lib/sdl.rb
	$(Q) $(INSTALL_DATA) $(srcdir)/lib/sdl.rb $(@D)
pre-install-rb-default:
	$(ECHO) installing default sdl_ext libraries
$(RUBYARCHDIR):
	$(Q) $(MAKEDIRS) $@
$(RUBYLIBDIR):
	$(Q) $(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .mm .cxx .cpp .C .o

.cc.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.mm.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cxx.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cpp.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.C.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.c.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $<

.m.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $<

$(DLLIB): $(OBJS) Makefile
	$(ECHO) linking shared-object $(DLLIB)
	@-$(RM) $(@)
	$(Q) $(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



###
rubysdl_event.o: rubysdl_event.c rubysdl.h
rubysdl_event_key.o: rubysdl_event_key.c rubysdl.h
rubysdl_main.o: rubysdl_main.c rubysdl.h
rubysdl_video.o: rubysdl_video.c rubysdl.h
rubysdl_mixer.o: rubysdl_mixer.c rubysdl.h
rubysdl_time.o: rubysdl_time.c rubysdl.h
rubysdl_wm.o: rubysdl_wm.c rubysdl.h
rubysdl_mouse.o: rubysdl_mouse.c rubysdl.h
rubysdl_sge_video.o: rubysdl_sge_video.c rubysdl.h
rubysdl_image.o: rubysdl_image.c rubysdl.h
rubysdl_ttf.o: rubysdl_ttf.c rubysdl.h
rubysdl_joystick.o: rubysdl_joystick.c rubysdl.h
rubysdl_cdrom.o: rubysdl_cdrom.c rubysdl.h
rubysdl_pixel.o: rubysdl_pixel.c rubysdl.h
rubysdl_smpeg.o: rubysdl_smpeg.c rubysdl.h
rubysdl_sdlskk.o: rubysdl_sdlskk.c rubysdl.h
rubysdl_kanji.o: rubysdl_kanji.c rubysdl.h SDL_kanji.h
SDL_kanji.o: SDL_kanji.c SDL_kanji.h
