;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

;; variants of auto-save-buffers.
;; http://0xcc.net/unimag/12/
;; http://0xcc.net/misc/auto-save/auto-save-buffers.el
;; http://homepage3.nifty.com/oatu/emacs/archives/auto-save-buffers.el

(and (require 'auto-save-buffers nil t)
     (run-with-idle-timer 0.5 t 'auto-save-buffers))