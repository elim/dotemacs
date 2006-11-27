;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'elscreen nil t)
  (require 'elscreen-dired nil t)
  (require 'elscreen-server nil t)
  (when (locate-library "howm")
    (require 'elscreen-howm nil t))
  (when (locate-library "w3m")
    (require 'elscreen-w3m nil t))
  (when (locate-library "wl")
    (require 'elscreen-wl nil t))
  (elscreen-set-prefix-key "\C-l")
  (setq elscreen-display-tab t))

;; elscreen-wl が無くとも変更. 慣れたので.
(add-hook
 'wl-draft-mode-hook
 '(lambda ()
    (progn
      (define-key (current-local-map) "\C-l"
	nil)
      (define-key (current-local-map) "\C-cl"
	'wl-draft-highlight-and-recenter)
      (define-key (current-local-map) "\C-c\C-l"
	'wl-draft-highlight-and-recenter))))