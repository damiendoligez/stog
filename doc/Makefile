#################################################################################
#                Stog                                                           #
#                                                                               #
#    Copyright (C) 2012 Maxence Guesdon. All rights reserved.                   #
#                                                                               #
#    This program is free software; you can redistribute it and/or modify       #
#    it under the terms of the GNU General Public License as                    #
#    published by the Free Software Foundation; either version 2 of the         #
#    License.                                                                   #
#                                                                               #
#    This program is distributed in the hope that it will be useful,            #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#    GNU Library General Public License for more details.                       #
#                                                                               #
#    You should have received a copy of the GNU General Public                  #
#    License along with this program; if not, write to the Free Software        #
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA                   #
#    02111-1307  USA                                                            #
#                                                                               #
#    As a special exception, you have permission to link this program           #
#    with the OCaml compiler and distribute executables, as long as you         #
#    follow the requirements of the GNU GPL in regard to all of the             #
#    software in the executable aside from the OCaml compiler.                  #
#                                                                               #
#    Contact: Maxence.Guesdon@inria.fr                                          #
#                                                                               #
#################################################################################

STOGDIR=..
STOG=$(STOGDIR)/stog
DEST_DIR=`pwd`/../doc-output
BASE_URL_OPTION=
STOG_OPTIONS=-d $(DEST_DIR) $(BASE_URL_OPTION)
LESSC=lessc

.PHONY: build site test

build:
	rm -fr $(DEST_DIR)/*
	$(MAKE) site


site:
	$(STOG) $(STOG_OPTIONS) .
	$(LESSC) tmpl/style.less > $(DEST_DIR)/style.css
	cp -f *png tmpl/*png $(DEST_DIR)/
#	cp -f *.svg $(DEST_DIR)/

test:
	$(MAKE) BASE_URL_OPTION="--site-url file://$(DEST_DIR)" site