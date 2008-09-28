;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; Carbon Emacs
(when (eq window-system 'mac)
  (setq mac-pass-control-to-system nil
        mac-pass-command-to-system nil
        mac-option-modifier 'meta))