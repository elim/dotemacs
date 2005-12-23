;; -*- emacs-lisp -*-
;; $Id$

;; for Debian package.
(eval-safe
 (unload-feature 'elscreen))

(setq elscreen-prefix-key "\C-l"
      elscreen-display-tab "nil")

(when (require 'elscreen)
  (setq elscreen-mode-to-nickname-alist
	(append
	 '(("^howm-" . "howm")
	   ("^riece-" . "riece")
	   ("^navi2ch-" . "navi2ch"))
	 elscreen-mode-to-nickname-alist))
  (eval-safe (require 'elscreen-dired))
  (eval-safe (require 'elscreen-howm))
  (eval-safe (require 'elscreen-server))
  (eval-safe (require 'elscreen-w3m))
  (eval-safe (require 'elscreen-wl)))

;; elscreen が無くとも変更. 慣れたので.
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