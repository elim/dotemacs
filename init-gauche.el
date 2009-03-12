;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'gauche-mode nil t)
  (setq auto-mode-alist
        (cons '("\\.scm$" . gauche-mode) auto-mode-alist)))