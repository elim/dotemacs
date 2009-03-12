;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'autoinsert nil t)
  (auto-insert-mode 1)
  (setq auto-insert-query nil))