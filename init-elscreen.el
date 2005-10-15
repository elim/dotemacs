; -*- emacs-lisp -*-
; $Id$

(eval-safe
 (unload-feature 'elscreen))

(setq elscreen-prefix-key "\C-l")
(eval-safe (require 'elscreen))
(eval-safe (require 'elscreen-wl))
(eval-safe (require 'elscreen-w3m))
(eval-safe (require 'elscreen-dired))

(setq elscreen-mode-to-nickname-alist
      (append
       '(("^howm-" . "howm")
	 ("^riece-" . "riece")
	 ("^navi2ch-" . "navi2ch")) 
       elscreen-mode-to-nickname-alist))

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


