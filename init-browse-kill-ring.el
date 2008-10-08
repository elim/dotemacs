;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'browse-kill-ring nil t)
  (define-key ctl-x-map "\C-y" 'browse-kill-ring)
  (setq browse-kill-ring-display-style 'separated
        browse-kill-ring-quit-action 'kill-and-delete-window
        browse-kill-ring-resize-window nil
        browse-kill-ring-separator "-------"
        browse-kill-ring-highlight-current-entry t
        browse-kill-ring-separator-face 'region
        browse-kill-ring-maximum-display-length 100))
