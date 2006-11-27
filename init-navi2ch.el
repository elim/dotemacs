;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (autoload-if-found
       'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)
  (setq navi2ch-mona-enable t)
  (setq navi2ch-list-bbstable-url
	"http://azlucky.s25.xrea.com/2chboard/bbsmenu2.html"))