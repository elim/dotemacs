;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'browse-kill-ring nil t)
  (define-key ctl-x-map "\C-y" 'browse-kill-ring)
  (setq browse-kill-ring-display-style 'separated)
  (setq browse-kill-ring-quit-action 'kill-and-delete-window)
  (setq browse-kill-ring-resize-window nil)
  (setq browse-kill-ring-separator "-------")
  (setq browse-kill-ring-highlight-current-entry t)
  (setq browse-kill-ring-separator-face 'region)
  (setq browse-kill-ring-maximum-display-length 100))