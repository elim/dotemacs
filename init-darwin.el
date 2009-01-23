;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(cond
 (carbon-p
  (setq mac-pass-control-to-system nil
        mac-pass-command-to-system nil
        mac-option-modifier 'meta))
 (ns-p
  (setq ns-command-modifier 'meta)))
