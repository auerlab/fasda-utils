############################################################################
#
#              Another Programmer's Editor Makefile Template
#
# This is a template Makefile for a simple program.
# It is meant to serve as a starting point for creating a portable
# Makefile, suitable for use under ports systems like *BSD ports,
# MacPorts, Gentoo Portage, etc.
#
# The goal is a Makefile that can be used without modifications
# on any Unix-compatible system.
#
# Variables that are conditionally assigned (with ?=) can be overridden
# by the environment or via the command line as follows:
#
#       make VAR=value
#
# For example, MacPorts installs to /opt/local instead of the default
# ../local, and hence might use the following:
# 
#       make PREFIX=/opt/local
#
# Different systems may also use different compilers and keep libraries in
# different locations:
#
#       make CC=gcc CFLAGS=-O2 LDFLAGS="-L/usr/X11R6 -lX11"
#
# Variables can also inheret values from parent Makefiles (as in *BSD ports).
#
# Lastly, they can be overridden by the environment, e.g.
# 
#       setenv CFLAGS "-O -Wall -pipe"  # C-shell and derivatives
#       export CFLAGS="-O -Wall -pipe"  # Bourne-shell and derivatives
#       make
#
# All these override methods allow the Makefile to respect the environment
# in which it is used.
#
# You can append values to variables within this Makefile (with +=).
# However, this should not be used to add compiler-specific flags like
# -Wall, as this would disrespect the environment.
#
#   History: 
#   Date        Name        Modification
#   2022-04-04  Jason Bacon Begin
############################################################################

############################################################################
# Installed targets

############################################################################
# Compile, link, and install options

# Install in ../local, unless defined by the parent Makefile, the
# environment, or a command line option such as PREFIX=/opt/local.
# FreeBSD ports sets this to /usr/local, MacPorts to /opt/local, etc.
PREFIX      ?= ../local

# Where to find local libraries and headers.  If you want to use libraries
# from outside ${PREFIX} (not usually recommended), you can set this
# independently.
LOCALBASE   ?= ${PREFIX}

# Allow caller to override either MANPREFIX or MANDIR
MANPREFIX   ?= ${PREFIX}
MANDIR      ?= ${MANPREFIX}/man
# FIXME: Need to realpath this if relative (e.g. ../local) or fasda won't
# find subcommands from arbitrary CWD
# Currently must use cave-man-install.sh for this until a bmake/gmake
# portable method is found
LIBEXECDIR  ?= ${PREFIX}/libexec/fasda

# No full pathnames for these.  Allow PATH to dtermine which one is used
# in case a locally installed version is preferred.
MKDIR   ?= mkdir
INSTALL ?= install
SED     ?= sed
CHMOD   ?= chmod

############################################################################
# Standard targets required by package managers

.PHONY: all install help

all:

clean:

############################################################################
# Install all target files (binaries, libraries, docs, etc.)

install: all
	${MKDIR} -p ${DESTDIR}${LIBEXECDIR} ${DESTDIR}${MANDIR}/man1
	${INSTALL} -m 0755 ${LIBEXEC} Scripts/* ${DESTDIR}${LIBEXECDIR}
	${SED} -e "s|/usr/local|`realpath ${PREFIX}`|g" Scripts/heatmap \
	    > ${DESTDIR}${LIBEXECDIR}/heatmap
	${CHMOD} 755 ${DESTDIR}${LIBEXECDIR}/heatmap
	${INSTALL} -m 0644 Man/*.1 ${DESTDIR}${MANDIR}/man1

help:
	@printf "Usage: make [VARIABLE=value ...] all\n\n"
	@printf "Some common tunable variables:\n\n"
	@printf "\tCC        [currently ${CC}]\n"
	@printf "\tCFLAGS    [currently ${CFLAGS}]\n"
	@printf "\tCXX       [currently ${CXX}]\n"
	@printf "\tCXXFLAGS  [currently ${CXXFLAGS}]\n"
	@printf "\tF77       [currently ${F77}]\n"
	@printf "\tFC        [currently ${FC}]\n"
	@printf "\tFFLAGS    [currently ${FFLAGS}]\n\n"
	@printf "View Makefile for more tunable variables.\n\n"

