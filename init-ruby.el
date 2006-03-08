;; -*- emacs-lisp -*-
; $Id$

(when (autoload-if-found 'ruby-mode "ruby-mode" nil t)
  (setq auto-mode-alist
	(cons (cons "\\.rb$" 'ruby-mode) auto-mode-alist))
  (setq ruby-indent-level 2)
  (setq ruby-indent-tabs-mode nil))
