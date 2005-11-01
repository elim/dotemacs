;-*- emacs-lisp -*-
; $Id$

(iswitchb-mode 1)

(add-hook 'iswitchb-define-mode-map-hook
	  (lambda ()
	    (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
	    (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
	    (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
	    (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)))

(setq iswitchb-buffer-ignore
      (append
       '("\\`[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\.howm\\'"
	 "\\.howm-keys"
	 "\\*WL.*"
	 "\\*Channel.*"
	 ".*skk.*"
	 "\\*\\(IMAP|NNTP|SMTP\\).*"
	 iswitchb-buffer-ignore)))
