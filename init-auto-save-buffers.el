;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
(when (require 'auto-save-buffers nil t)
  (run-with-idle-timer 2 t 'auto-save-buffers))