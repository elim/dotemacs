;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-
;;; $Id$

(when (functionp 'server-start)
  (setq server-window 'pop-to-buffer)
  (server-start))