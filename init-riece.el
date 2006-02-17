;; -*- emacs-lisp -*-
;; $Id$

(when (autoload-if-found 'riece "riece" nil t)
  (setq riece-server-alist '(("Tiarra" :host "elim.teroknor.org")))
  (setq riece-server "Tiarra")
  (setq riece-channel-buffer-mode 't)
  (setq riece-user-list-buffer-mode 't)
  (setq riece-layout '"middle-left")

  (setq riece-directory
	(expand-file-name (concat my-lisp-path "/riece")))
  (setq riece-addon-directory
	(expand-file-name (concat riece-directory "/addons")))
  (setq riece-saved-variables-file
	(expand-file-name (concat riece-directory "/save")))
  (setq riece-variables-file
	(expand-file-name (concat riece-directory "/init")))

  (setq riece-variables-files
	(list riece-variables-file
	  riece-saved-variables-file))

  (setq riece-saved-forms
	'(riece-channel-buffer-mode
	  riece-others-buffer-mode
	  riece-user-list-buffer-mode
	  riece-channel-list-buffer-mode
	  riece-layout riece-addons))

  (setq riece-addons
	'(riece-alias
	  riece-button
	  riece-ctcp riece-guess riece-highlight
	  riece-history riece-icon riece-keyword
	  riece-menu riece-skk-kakutei riece-unread
	  riece-url))

  (setq riece-ndcc-server-address "localhost")

  (setq riece-keywords '("Elim" "elim" "えりむ" "エリム"
			 "えろり" "えろむ" "女の敵"))

  (when (and (locate-library "esdplay" nil exec-path)
	     (file-exists-p (expand-file-name "~/sounds/notify.wav")))
    (add-hook 'riece-notify-keyword-functions
	      (lambda (keyword)
		(start-process "You were called." "*Messages*" "esdplay"
			       (expand-file-name "~/sounds/notify.wav")))))

  (add-hook 'riece-startup-hook
	    (lambda ()
	      (define-key riece-command-mode-map "\C-xn"
		'riece-command-enter-message-as-notice))))

