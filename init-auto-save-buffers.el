;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; variants of auto-save-buffers.
;; http://0xcc.net/unimag/12/
;; http://0xcc.net/misc/auto-save/auto-save-buffers.el
;; (w3m "http://homepage3.nifty.com/oatu/emacs/archives/auto-save-buffers.el")
;; (auto-install-from-w3m)

(and (require 'auto-save-buffers nil t)
     (setq auto-save-buffers-interval 0.5)
     (run-with-idle-timer auto-save-buffers-interval t
                          'auto-save-buffers))