;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (functionp 'server-start)
  (setq server-window 'pop-to-buffer)
  (server-start)
  (remove-hook
   'kill-buffer-query-functions
   'server-kill-buffer-query-function))
