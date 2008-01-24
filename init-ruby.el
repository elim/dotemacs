;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'ruby-mode nil t)
  (require 'inf-ruby nil t)
  (require 'ruby-electric nil t)

  (setq ruby-indent-level 2
	ruby-indent-tabs-mode nil

	auto-mode-alist
	(append '(("\\.rb$" . ruby-mode)) auto-mode-alist)

	interpreter-mode-alist
	(append '(("ruby" . ruby-mode)) interpreter-mode-alist))

  (add-hook 'ruby-mode-hook
	    '(lambda ()
	       (inf-ruby-keys))))