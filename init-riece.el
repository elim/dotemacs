;-*- emcs-lisp -*-
; $Id$
(setq riece-server-alist '(("Tiarra" :host "logic.fascinating.lan")))
(setq riece-server "Tiarra")
(setq riece-channel-buffer-mode 't)
(setq riece-user-list-buffer-mode 't)
(setq riece-layout '"middle-left")

(setq riece-addons '(riece-alias riece-button
				 riece-ctcp riece-guess riece-highlight
				 riece-history riece-icon riece-keyword
				 riece-menu riece-skk-kakutei riece-unread
				 riece-url))
(setq riece-ndcc-server-address "localhost")

(setq riece-keywords '("Elim" "elim" "えりむ" "エリム"
		       "えろり" "えろむ" "女の敵"))

(add-hook 'riece-notify-keyword-functions
	  (lambda (keyword) (start-process "call me" "*scratch*" "esdplay"
					   "/home/takeru/sounds/notify.wav")))

(add-hook 'riece-startup-hook
	  (lambda ()
	    (define-key riece-command-mode-map "\C-xn"
	      'riece-command-enter-message-as-notice)))

