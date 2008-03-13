;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (autoload-if-found 'riece "riece" nil t)

  ;; server settings
  (setq riece-server-alist
	'(("default"
	  :host "localhost"
	  :service 6667
	  :coding utf-8))
	riece-server "default"
	riece-ndcc-server-address "localhost"
	riece-channel-buffer-mode 't
	riece-user-list-buffer-mode 't
	riece-layout '"middle-left")

  ;; fils and directories
  (setq riece-preference-directory
	(expand-file-name "riece" base-directory)

	riece-addon-directory
	(expand-file-name "addons" riece-preference-directory)

	riece-saved-variables-file
	(expand-file-name "save" riece-preference-directory)

	riece-variables-file
	(expand-file-name "init" riece-preference-directory))

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

  (setq riece-keywords '("Elim" "elim"
			 "えりむ" "エリム"
			 "えろり" "えろむ"
			 "lisp" "emacs"))

  (let
      ((notify-sound-file (expand-file-name "~/sounds/notify.wav"))
       (notify-sound-player "mplayer"))

    (when (and (locate-executable notify-sound-player)
	       (file-exists-p notify-sound-file))
       (add-hook 'riece-notify-keyword-functions
		 `(lambda (keyword)
		    (start-process keyword "*Messages*" ,notify-sound-player
				   (expand-file-name ,notify-sound-file))))))

  (add-hook 'riece-startup-hook
	    (lambda ()
	      (define-key riece-command-mode-map "\C-xn"
		'riece-command-enter-message-as-notice))))