;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when window-system
  (setq-default line-spacing 4)

  (add-hook 'window-setup-hook #'frame-fullscreen))
