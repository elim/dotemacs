;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'rinari nil t)
  (when (require 'rhtml-mode nil t)
    (add-hook 'rhtml-mode-hook
              (lambda () (rinari-launch)))))
