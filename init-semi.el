;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;;; based upon dot.wl

;; Disable inline display of HTML part.
;; Put before load `mime-setup'
(setq mime-setup-enable-inline-html t)

;; Don't split large message.
(setq mime-edit-split-message nil)

;; If lines of message are larger than this value, treat it as `large'.
;(setq mime-edit-message-default-max-lines 1000)

(load "mime-setup" t)