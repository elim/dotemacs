;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when window-system
  (setq-default line-spacing 4)
  (setq default-frame-alist (append
                             '((foreground-color . "gray")
                               (background-color . "black")
                               (cursor-color  . "blue"))
                             default-frame-alist)))

  (add-hook 'window-setup-hook #'frame-fullscreen))
