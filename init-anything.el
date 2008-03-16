;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (and (require 'anything nil t)
	   (require 'anything-config nil t))
  (mapc '(lambda (key)
	   (global-set-key key 'anything))
	(list [(control x)(b)]
	      [(control x)(C-f)]
	      [(control x)(right)])))