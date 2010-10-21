;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; (w3m "http://www.jpl.org/elips/develock.el.gz")
;; (auto-install-from-buffer)
(when (require 'develock nil t)
  (set-face-foreground 'develock-reachable-mail-address "DarkGreen")
  (set-face-background 'develock-reachable-mail-address "black"))
