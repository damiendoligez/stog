(**************************************************************************)
(*              Stog                                                      *)
(*                                                                        *)
(*  Copyright (C) 2014 Maxence Guesdon. All rights reserved.              *)
(*                                                                        *)
(*  This program is free software; you can redistribute it and/or modify  *)
(*  it under the terms of the GNU General Public License as               *)
(*  published by the Free Software Foundation; either version 2 of the    *)
(*  License.                                                              *)
(*                                                                        *)
(*  This program is distributed in the hope that it will be useful,       *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Library General Public License for more details.                  *)
(*                                                                        *)
(*  You should have received a copy of the GNU General Public             *)
(*  License along with this program; if not, write to the Free Software   *)
(*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA              *)
(*  02111-1307  USA                                                       *)
(*                                                                        *)
(*  As a special exception, you have permission to link this program      *)
(*  with the OCaml compiler and distribute executables, as long as you    *)
(*  follow the requirements of the GNU GPL in regard to all of the        *)
(*  software in the executable aside from the OCaml compiler.             *)
(*                                                                        *)
(*  Contact: Maxence.Guesdon@inria.fr                                     *)
(*                                                                        *)
(**************************************************************************)

(** Highlighting code. *)


(** Call the highlight command on the given string and make it produce xhtml code.
  Options are passed to the highlight command. *)
val external_highlight : opts:string -> string -> Xtmpl.tree list

(** Highlight the given code.
  If a lang and no option are given, then Higlo is tried first.
  If the language is unknown, we fallback to using external highlight command.
  @param lang is used to indicate the language.
  @opts are options passed to highlight command.
*)
val highlight : ?lang: string -> ?opts: string -> string -> Xtmpl.tree list