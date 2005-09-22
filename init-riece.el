;-*- emacs-lisp -*-
; $Id$

(autoload 'riece "riece" nil t)

(setq riece-server-alist '(("Tiarra" :host "elim.teroknor.org")))
(setq riece-server "Tiarra")
(setq riece-channel-buffer-mode 't)
(setq riece-user-list-buffer-mode 't)
(setq riece-layout '"middle-left")

(setq riece-addons
      '(riece-alias riece-button
		    riece-ctcp riece-guess riece-highlight
		    riece-history riece-icon riece-keyword
		    riece-menu riece-skk-kakutei riece-unread
		    riece-url))
(setq riece-ndcc-server-address "localhost")

(setq riece-keywords '("Elim" "elim" "$B$($j$`(B" "$B%(%j%`(B"
		       "$B$($m$j(B" "$B$($m$`(B" "$B=w$NE((B"))

(add-hook 'riece-notify-keyword-functions
	  (lambda (keyword)
	    (eval-safe
	     (start-process "call me." "*Messages*" "esdplay"
			    (expand-file-name "~/sounds/notify.wav")))))

(add-hook 'riece-startup-hook
	  (lambda ()
	    (define-key riece-command-mode-map "\C-xn"
	      'riece-command-enter-message-as-notice)))


