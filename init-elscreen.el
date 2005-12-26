;; -*- emacs-lisp -*-
;; $Id$

;; for Debian package.
(eval-safe
 (unload-feature 'elscreen))

(setq elscreen-prefix-key "\C-l"
      elscreen-display-tab "nil")

(when (require 'elscreen nil t)
  (require 'elscreen-dired nil t)
  (require 'elscreen-howm nil t)
  (require 'elscreen-server nil t)
  (require 'elscreen-w3m nil t)
  (require 'elscreen-wl nil t))
  (setq elscreen-mode-to-nickname-alist
	(append
	 '(("^howm-" . "howm")
	   ("^riece-" . "riece")
	   ("^navi2ch-" . "navi2ch"))
	 elscreen-mode-to-nickname-alist))

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