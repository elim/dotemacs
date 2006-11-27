;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (autoload-if-found 'html-helper-mode "html-helper-mode" "Yay HTML" t)
  (setq html-helper-new-buffer-template nil)
  (setq html-helper-do-write-file-hooks t)
  (setq html-helper-build-new-buffer nil)
  (setq html-helper-basic-offset 1)
  (setq html-helper-item-continue-indent 2)
  (setq html-helper-address-string "elim@teroknor.org")
  (setq auto-mode-alist
	(cons '("\\.html$" . html-helper-mode) auto-mode-alist)))