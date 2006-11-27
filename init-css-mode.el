;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (autoload-if-found 'css-mode "css-mode" nil t nil)
  (setq auto-mode-alist
	(cons '("\\.css\\'" . css-mode) auto-mode-alist))
  (setq cssm-indent-function #'cssm-c-style-indenter))

