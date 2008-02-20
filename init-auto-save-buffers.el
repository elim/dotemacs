;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
(when (require 'auto-save-buffers nil t)
  (run-with-idle-timer 0.5 t 'auto-save-buffers))