;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'hideshow nil t)
  (define-key hs-minor-mode-map
    (kbd "C-c C-M-c") 'hs-toggle-hiding))
