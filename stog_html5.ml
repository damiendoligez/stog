(*********************************************************************************)
(*                Stog                                                           *)
(*                                                                               *)
(*    Copyright (C) 2012-2014 Maxence Guesdon. All rights reserved.              *)
(*                                                                               *)
(*    This program is free software; you can redistribute it and/or modify       *)
(*    it under the terms of the GNU General Public License as                    *)
(*    published by the Free Software Foundation, version 3 of the License.       *)
(*                                                                               *)
(*    This program is distributed in the hope that it will be useful,            *)
(*    but WITHOUT ANY WARRANTY; without even the implied warranty of             *)
(*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               *)
(*    GNU Library General Public License for more details.                       *)
(*                                                                               *)
(*    You should have received a copy of the GNU General Public                  *)
(*    License along with this program; if not, write to the Free Software        *)
(*    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA                   *)
(*    02111-1307  USA                                                            *)
(*                                                                               *)
(*    As a special exception, you have permission to link this program           *)
(*    with the OCaml compiler and distribute executables, as long as you         *)
(*    follow the requirements of the GNU GPL in regard to all of the             *)
(*    software in the executable aside from the OCaml compiler.                  *)
(*                                                                               *)
(*    Contact: Maxence.Guesdon@inria.fr                                          *)
(*                                                                               *)
(*********************************************************************************)


let void_tags =
  List.fold_right Stog_types.Str_set.add
    [ "area" ; "base" ; "br" ; "col" ; "embed" ; "hr" ; "img" ; "input" ;
      "keygen" ; "link" ; "meta" ; "param" ; "source" ; "track" ; "wbr" ;
    ]
    Stog_types.Str_set.empty
;;

let is_void_tag t = Stog_types.Str_set.mem t void_tags;;

let hack_self_closed =
  let rec iter xml =
    match xml with
      Xtmpl.D _ -> xml
    | Xtmpl.E (("", tag),atts,[]) when not (is_void_tag tag) ->
        Xtmpl.E (("", tag), atts, [Xtmpl.D ""])
    | Xtmpl.E (tag, atts, subs) ->
      Xtmpl.E (tag, atts, List.map iter subs)
  in
  iter
;;