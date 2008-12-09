;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'egg nil t)
  (load "egg-grep" t)
  (add-hook 'dired-mode-hook
            '(lambda ()
               (define-key dired-mode-map "V" 'egg-status))))
