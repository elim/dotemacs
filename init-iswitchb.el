;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'iswitchb nil t)
  (iswitchb-mode 1)
  (setq iswitchb-regexp t)
  (setq iswitchb-buffer-ignore
	(append
	 '("\\`[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\.howm\\'"
	   "\\.howm-keys"
	   "\\*WL.*"
	   "\\*Channel.*"
	   ".*skk.*"
	   "\\*\\(IMAP|NNTP|SMTP\\).*"
	   iswitchb-buffer-ignore)))

  (add-hook
   'iswitchb-define-mode-map-hook
   (lambda ()
     (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
     (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
     (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
     (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match))))

