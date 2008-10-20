;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload-if-found 'css-mode "css-mode" nil t nil)
  (setq css-indent-offset 2))