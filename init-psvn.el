;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'psvn nil t)
  (setq svn-status-hide-unmodified t
        svn-status-coding-system 'utf-8-unix))
