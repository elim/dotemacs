;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'psvn nil t)
  (setq svn-status-hide-unmodified t)
  (setq process-coding-system-alist
	(cons '("svn" . utf-8) process-coding-system-alist))
  (add-hook 'dired-mode-hook
	    '(lambda ()
	       ;;(define-key dired-mode-map "V" 'cvs-examine)
	       (define-key dired-mode-map "V" 'svn-status)
	       (turn-on-font-lock))))
