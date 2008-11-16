;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload-if-found 'tiarra-conf-mode "tiarra-conf")
  (cons '("tiarra.conf" . tiarra-conf-mode) auto-mode-alist))