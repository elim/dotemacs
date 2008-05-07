;;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;;; $Id$

(when (require 'psvn nil t)
  (setq svn-status-hide-unmodified t
	svn-status-coding-system 'utf-8-unix)

  (add-hook 'dired-mode-hook
	    '(lambda ()
	       (define-key dired-mode-map "V" 'svn-status)
	       (turn-on-font-lock))))
