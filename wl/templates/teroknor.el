;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 `(,(file-name-sans-extension
     (file-name-nondirectory load-file-name))
   (wl-from . "elim garak <elim@teroknor.org>")
   ("From" . wl-from)))