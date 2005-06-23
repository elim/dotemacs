;-*- emacs-lisp -*-
; $Id$

(iswitchb-mode 1)

(add-hook 'iswitchb-define-mode-map-hook
	  (lambda ()
	    (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
	    (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
	    (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
	    (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)))

(add-to-list 'iswitchb-buffer-ignore
	     "\\`[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\.howm\\'"
	     "\\`\\.keys\\'")