;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload-if-found 'apache-mode "apache-mode"
                         "editing Apache configuration files." t)
  (setq apache-indent-level 4))
