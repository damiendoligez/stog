#################################################################################
#                Stog                                                           #
#                                                                               #
#    Copyright (C) 2012-2014 Maxence Guesdon. All rights reserved.              #
#                                                                               #
#    This program is free software; you can redistribute it and/or modify       #
#    it under the terms of the GNU General Public License as                    #
#    published by the Free Software Foundation, version 3 of the License.       #
#                                                                               #
#    This program is distributed in the hope that it will be useful,            #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               #
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

include master.Makefile

P=#p -p
PBYTE=#p -p a

OF_FLAGS=-package $(PACKAGES),$(SERVER_PACKAGES)

COMPFLAGS=-I +ocamldoc -annot -rectypes -g -thread  #-w +K
OCAMLPP=

PLUGINS_BYTE= \
	plugins/stog_asy.cmo \
	plugins/stog_disqus.cmo \
	plugins/stog_dot.cmo \
	plugins/stog_markdown.cmo \
	plugins/stog_multi_doc.cmo \
	plugins/stog_rel_href.cmo \
	plugins/plugin_example.cmo
PLUGINS_OPT=$(PLUGINS_BYTE:.cmo=.cmxs)

ODOC=odoc_stog.cmxs
ODOC_BYTE=$(ODOC:.cmxs=.cmo)

RM=rm -f
CP=cp -f
MKDIR=mkdir -p

LIB_CMXFILES= \
	stog_install.cmx \
	stog_msg.cmx \
	stog_misc.cmx \
	stog_highlight.cmx \
	stog_config.cmx \
	stog_trie.cmx \
	stog_tmap.cmx \
	stog_graph.cmx \
	stog_path.cmx \
	stog_filter_types.cmx \
	stog_types.cmx \
	stog_intl.cmx \
	stog_find.cmx \
	stog_tags.cmx \
	stog_io.cmx \
	stog_info.cmx \
	stog_ocaml_types.cmx \
	stog_deps.cmx \
	stog_tmpl.cmx \
	stog_filter_parser.cmx \
	stog_filter_lexer.cmx \
	stog_filter.cmx \
	stog_html5.cmx \
	stog_engine.cmx \
	stog_ocaml.cmx \
	stog_svg.cmx \
	stog_of_latex.cmx \
	stog_latex.cmx \
	stog_cut.cmx \
	stog_list.cmx \
	stog_html.cmx \
	stog_blocks.cmx \
	stog_plug.cmx \
	stog_dyn.cmx \
	stog_server_mode.cmx

LIB_CMOFILES=$(LIB_CMXFILES:.cmx=.cmo)
LIB_CMIFILES=$(LIB_CMXFILES:.cmx=.cmi)

LIB=stog.cmxa
LIB_CMXS=$(LIB:.cmxa=.cmxs)
LIB_BYTE=$(LIB:.cmxa=.cma)

LIB_SERVER=stog_server.cmxa
LIB_SERVER_CMXS=$(LIB_SERVER:.cmxa=.cmxs)
LIB_SERVER_BYTE=$(LIB_SERVER:.cmxa=.cma)

MAIN=stog
MAIN_BYTE=$(MAIN).byte

LIB_SERVER_CMXFILES= \
	stog_server_types.cmx \
	stog_server_run.cmx \
	stog_server_files.cmx \
	stog_server_ws.cmx \
	stog_server_preview.cmx \
	stog_server_main.cmx

LIB_SERVER_CMOFILES=$(LIB_SERVER_CMXFILES:.cmx=.cmo)
LIB_SERVER_CMIFILES=$(LIB_SERVER_CMXFILES:.cmx=.cmi)

SERVER_JS=stog_server_client.js

OCAML_SESSION=$(MAIN)-ocaml-session

MK_STOG=mk-$(MAIN)
MK_STOG_BYTE=mk-$(MAIN_BYTE)
MK_STOG_OCAML=mk-$(OCAML_SESSION)

LATEX2STOG=latex2stog
LATEX2STOG_BYTE=latex2stog.byte

OCAML_SESSION_CMOFILES= \
	stog_ocaml_types.cmo \
	stog_misc.cmo \
	stog_ocaml_session.cmo
OCAML_SESSION_CMIFILES=$(OCAML_SESSION_CMOFILES:.cmo=.cmi)

all: opt byte

opt: $(LIB) $(LIB_CMXS) $(MAIN) $(SERVER) $(LATEX2STOG) \
	plugins/plugin_example.cmxs $(PLUGINS_OPT) \
	$(MK_STOG) $(ODOC)

byte: $(LIB_BYTE) $(MAIN_BYTE) $(SERVER_BYTE) $(LATEX2STOG_BYTE) \
	$(OCAML_SESSION) plugins/plugin_example.cmo $(PLUGINS_BYTE) \
	$(MK_STOG_BYTE) $(MK_STOG_OCAML) $(ODOC_BYTE)

$(MAIN): $(LIB) stog_main.cmx
	$(OCAMLFIND) ocamlopt$(P) -package $(PACKAGES) -verbose -linkall -linkpkg -o $@ $(COMPFLAGS) $^

$(MAIN_BYTE): $(LIB_BYTE) stog_main.cmo
	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES) -linkall -linkpkg -o $@ $(COMPFLAGS) $^

$(SERVER): $(LIB) $(LIB_SERVER) $(LIB_SERVER_CMXS) stog_main.cmx
	$(OCAMLFIND) ocamlopt$(P) -package $(PACKAGES),$(SERVER_PACKAGES) \
	-verbose -linkall -linkpkg -o $@ $(COMPFLAGS) $(LIB) $(LIB_SERVER) stog_main.cmx

$(SERVER_BYTE): $(LIB_BYTE) $(LIB_SERVER_BYTE) stog_main.cmo
	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES),$(SERVER_PACKAGES) \
	-linkall -linkpkg -o $@ $(COMPFLAGS) $^

#	`$(OCAMLFIND) query -predicates byte -r -a-format compiler-libs.toplevel` $^

server_files/$(SERVER_JS): stog_server_types.cmi stog_server_types.cmo stog_server_client_js.ml
	$(MKDIR) server_files
	$(OCAMLFIND) ocamlc -o $@.byte $(COMPFLAGS) \
	-package js_of_ocaml,js_of_ocaml.syntax,xmldiff,xtmpl -syntax camlp4o -linkpkg \
	stog_server_types.cmo stog_server_client_js.ml
	$(JS_OF_OCAML) $@.byte -o $@

stog_server_files.ml: server_files/$(SERVER_JS)
	$(OCAML_CRUNCH) --mode=plain -e js -o $@ server_files
	$(RM) -r server_files

$(LIB): $(LIB_CMIFILES) $(LIB_CMXFILES)
	$(OCAMLFIND) ocamlopt$(P) -a -o $@ $(LIB_CMXFILES)

$(LIB_CMXS): $(LIB_CMIFILES) $(LIB_CMXFILES)
	$(OCAMLFIND) ocamlopt$(P) -shared -o $@ $(LIB_CMXFILES)

$(LIB_BYTE): $(LIB_CMIFILES) $(LIB_CMOFILES)
	$(OCAMLFIND) ocamlc$(PBYTE) -a -o $@ $(LIB_CMOFILES)

$(LIB_SERVER): $(LIB) $(LIB_SERVER_CMIFILES) $(LIB_SERVER_CMXFILES)
	$(OCAMLFIND) ocamlopt$(P) -a -o $@ $(LIB_SERVER_CMXFILES)

$(LIB_SERVER_CMXS): $(LIB) $(LIB_SERVER_CMIFILES) $(LIB_SERVER_CMXFILES)
	$(OCAMLFIND) ocamlopt$(P) -shared -o $@ $(LIB_SERVER_CMXFILES)

$(LIB_SERVER_BYTE): $(LIB_BYTE) $(LIB_SERVER_CMIFILES) $(LIB_SERVER_CMOFILES)
	$(OCAMLFIND) ocamlc$(PBYTE) -a -o $@ $(LIB_SERVER_CMOFILES)

$(OCAML_SESSION): $(OCAML_SESSION_CMIFILES) $(OCAML_SESSION_CMOFILES)
	$(OCAMLFIND) ocamlc$(PBYTE) -package $(OCAML_SESSION_PACKAGES) -linkpkg -linkall -o $@ $(COMPFLAGS) $(OCAML_SESSION_CMOFILES)

stog_ocaml_session.cmo: stog_ocaml_session.ml
	$(OCAMLFIND) ocamlc$(PBYTE) -package $(OCAML_SESSION_PACKAGES) $(COMPFLAGS) -c $<

$(LATEX2STOG): $(LIB) latex2stog.cmx
	$(OCAMLFIND) ocamlopt$(P) -o $@ -package $(PACKAGES) -linkall -linkpkg $^

$(LATEX2STOG_BYTE): $(LIB_BYTE) latex2stog.cmo
	$(OCAMLFIND) ocamlc$(P) -o $@ -package $(PACKAGES) -linkall -linkpkg $^

default-styles:
	lessc doc/less/default-page.less | cleancss -o share/templates/page-style.css
	lessc doc/less/default-article.less | cleancss -o share/templates/article-style.css

# mk scripts
$(MK_STOG): $(LIB)
	@echo -n "Creating $@... "
	@$(RM) $@
	@echo "# Multi-shell script.  Works under Bourne Shell, MPW Shell, zsh." > $@
	@echo "if : == x" >> $@
	@echo "then # Bourne Shell or zsh" >> $@
	@echo "  exec $(OCAMLFIND) ocamlopt -package stog -linkpkg -linkall \"\$$@\" stog_main.cmx" >> $@
	@echo "else #MPW Shell" >> $@
	@echo "  exec $(OCAMLFIND) ocamlopt -package stog -linkpkg -linkall {\"parameters\"} stog_main.cmx" >> $@
	@echo "End # uppercase E because \"end\" is a keyword in zsh" >> $@
	@echo "fi" >> $@
	@chmod ugo+rx $@
	@chmod a-w $@
	@echo done

$(MK_STOG_BYTE): $(LIB)
	@echo -n "Creating $@... "
	@$(RM) $@
	@echo "# Multi-shell script.  Works under Bourne Shell, MPW Shell, zsh." > $@
	@echo "if : == x" >> $@
	@echo "then # Bourne Shell or zsh" >> $@
	@echo "  exec $(OCAMLFIND) ocamlc -package stog -linkpkg -linkall \"\$$@\" stog_main.cmo" >> $@
	@echo "else #MPW Shell" >> $@
	@echo "  exec $(OCAMLFIND) ocamlc -package stog -linkpkg -linkall {\"parameters\"} stog_main.cmo" >> $@
	@echo "End # uppercase E because \"end\" is a keyword in zsh" >> $@
	@echo "fi" >> $@
	@chmod ugo+rx $@
	@chmod a-w $@
	@echo done

$(MK_STOG_OCAML): $(LIB) $(OCAML_SESSION_CMOFILES)
	@echo -n "Creating $@... "
	@$(RM) $@
	@echo "# Multi-shell script.  Works under Bourne Shell, MPW Shell, zsh." > $@
	@echo "if : == x" >> $@
	@echo "then # Bourne Shell or zsh" >> $@
	@echo "  exec $(OCAMLFIND) ocamlc -package $(OCAML_SESSION_PACKAGES) -linkpkg -I `ocamlfind printconf destdir`/stog -linkall \"\$$@\" $(OCAML_SESSION_CMOFILES)" >> $@
	@echo "else #MPW Shell" >> $@
	@echo "  exec $(OCAMLFIND) ocamlc -package $(OCAML_SESSION_PACKAGES) -linkpkg -I `ocamlfind printconf destdir`/stog -linkall {\"parameters\"} $(OCAML_SESSION_CMOFILES)" >> $@
	@echo "End # uppercase E because \"end\" is a keyword in zsh" >> $@
	@echo "fi" >> $@
	@chmod ugo+rx $@
	@chmod a-w $@
	@echo done


##########
.PHONY: doc webdoc ocamldoc

SOURCE_FILES=`ls $(LIB_CMXFILES:.cmx=.ml) $(LIB_CMXFILES:.cmx=.mli) 2>/dev/null | grep -v stog_filter_parser.mli`
ocamldoc:
	$(MKDIR) ocamldoc
	$(OCAMLFIND) ocamldoc -package $(PACKAGES) -rectypes -sort -d ocamldoc -html -t "Stog" \
	$(SOURCE_FILES)

PKGS := $(shell echo $(PACKAGES) | sed -e "s/,/ /g")
depocamldoc:
	$(MKDIR) ocamldoc
	$(OCAMLDOC) `$(OCAMLFIND) query -i-format $(PKGS) -r` \
	-rectypes -d ocamldoc -g odoc_depgraph.cmxs -t "Stog" \
	$(SOURCE_FILES)	-width 700 -height 700

doc:
	rm -fr doc-output/
	(cd doc && $(MAKE) test)

webdoc:
	(cd doc && $(MAKE) DEST_DIR=`pwd`/../../stog-pages)

docstog: $(ODOC)
	$(MKDIR) doc/ref-doc
	rm -fr doc/ref-doc/*html
	OCAMLFIND_COMMANDS="ocamldoc=ocamldoc.opt" \
	ocamldoc.opt -rectypes `$(OCAMLFIND) query -i-format $(PKGS) -r` -d doc/ref-doc \
	-t "Stog library reference documentation" -short-functors \
	-g odoc_depgraph.cmxs -g ./$(ODOC) -width 700 -height 700 -dot-reduce \
	-dot-options '-Nfontsize=40. -Granksep=0.1 -Earrowsize=3.0 -Ecolor="#444444" ' \
	$(SOURCE_FILES)

##########
install: install-lib install-share install-bin

install-lib:
	@$(OCAMLFIND) install stog META \
		$(PLUGINS_BYTE) $(PLUGINS_OPT) $(PLUGINS_OPT:.cmxs=.cmx) $(PLUGINS_OPT:.cmxs=.o) \
		$(LIB_CMIFILES) $(LIB_CMXFILES) $(LIB_CMXFILES:.cmx=.o) \
		$(LIB_BYTE) $(LIB) $(LIB:.cmxa=.a) $(LIB_CMXS) stog_main.cm* stog_main.o \
		`test -n "$(SERVER)" && echo $(LIB_SERVER) $(LIB_SERVER:.cmxa=.a) $(LIB_SERVER_CMXS) \
		    $(LIB_SERVER_CMXFILES:.cmx=.o) $(LIB_SERVER_CMXFILES) ` \
		`test -n "$(SERVER_BYTE)" && echo $(LIB_SERVER_BYTE)` \
		`(test -n "$(SERVER)" || test -n "$(SERVER_BYTE)") && echo $(LIB_SERVER_CMIFILES)` \
		$(OCAML_SESSION_CMOFILES)

install-share:
	$(MKDIR) $(SHARE_DIR)
	$(CP) -r share/templates $(SHARE_DIR)/
	$(CP) -r share/modules $(SHARE_DIR)/

install-bin:
	$(CP) $(MAIN) $(MAIN_BYTE) $(SERVER) $(SERVER_BYTE) $(OCAML_SESSION) \
	  $(MK_STOG) $(MK_STOG_BYTE) $(MK_STOG_OCAML) \
	  $(LATEX2STOG) $(LATEX2STOG_BYTE) \
		`dirname \`which $(OCAMLC)\``/
	$(CP) $(ODOC) $(ODOC_BYTE) `$(OCAMLFIND) ocamldoc -customdir`/

uninstall: uninstall-lib uninstall-share uninstall-bin

uninstall-lib:
	@$(OCAMLFIND) remove stog

uninstall-share:
	$(RM) -r $(SHARE_DIR)

uninstall-bin:
	for i in $(MAIN) $(MAIN_BYTE) $(SERVER) $(SERVER_BYTE) $(OCAML_SESSION) \
		$(MK_STOG) $(MK_STOG_BYTE) $(MK_STOG_OCAML) \
		$(LATEX2STOG) $(LATEX2STOG_BYTE) ; \
		do $(RM) `dirname \`which $(OCAMLC)\``/$$i; done

#####
clean:
	$(RM) stog_server_files.ml
	$(RM) *.cm* *.o *.a *.x *.annot
	$(RM) $(MAIN) $(MAIN_BYTE) $(SERVER) $(SERVER_BYTE)
	$(RM) $(MK_STOG) $(ML_STOG_BYTE) $(MK_STOG_OCAML)
	$(RM) $(LATEX2STOG) $(LATEX2STOG_BYTE)
	(cd plugins && $(RM) *.cm* *.o *.a *.x *.annot)

distclean: clean
	$(RM) master.Makefile stog_config.ml stog_install.ml META
	$(RM) -fr config.status autom4te.cache config.log ocaml_config.sh

# archive :
###########
archive:
	git archive --prefix=stog-$(VERSION)/ HEAD | gzip > ../stog-pages/stog-$(VERSION).tar.gz

# headers :
###########
HEADFILES= Makefile *.ml *.mli doc/Makefile configure configure.ac
headers:
	echo $(HEADFILES)
	headache -h header -c .headache_config `ls $(HEADFILES) | grep -v plugin_example`

noheaders:
	headache -r -c .headache_config `ls $(HEADFILES)`

# myself :
##########
master.Makefile: master.Makefile.in config.status \
	stog_config.ml.in \
	stog_install.ml.in \
	META.in
	./config.status

config.status: configure
	./config.status --recheck

configure: configure.ac
	autoconf

#############
.PRECIOUS: stog_filter_lexer.ml stog_filter_lexer.mli stog_filter_parser.ml stog_filter_parser.mli

#%.cmi:%.mli
#	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -c $<
#
#%.cmo:%.ml
#	if test -f `dirname $<`/`basename $< .ml`.mli && test ! -f `dirname $<`/`basename $< .ml`.cmi ; then \
#	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -c `dirname $<`/`basename $< .ml`.mli; fi
#	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -c $<
#
#%.cmi %.cmo:%.ml
#	if test -f `dirname $<`/`basename $< .ml`.mli && test ! -f `dirname $<`/`basename $< .ml`.cmi ; then \
#	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -c `dirname $<`/`basename $< .ml`.mli; fi
#	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -c $<
#
#%.cmx %.o:%.ml
#	$(OCAMLFIND) ocamlopt$(P) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -c $<
#
#%.cmxs: %.ml
#	$(OCAMLFIND) ocamlopt$(P) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -shared -o $@ $<
#
#%.ml:%.mll
#	$(OCAMLLEX) $<
#
stog_filter_lexer.mli: stog_filter_lexer.ml
	$(OCAMLFIND) ocamlc$(PBYTE) -package $(PACKAGES) $(OCAMLPP) $(COMPFLAGS) -i $^ > $@

#%.mli %.ml:%.mly
#	$(OCAMLYACC) -v $<

$(PLUGINS_BYTE): $(LIB_BYTE)
$(PLUGINS_OPT): $(LIB)

.PHONY: clean depend

.depend depend:
	$(OCAMLFIND) ocamldep stog*.ml stog*.mli > .depend

include .depend
