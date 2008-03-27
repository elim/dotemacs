;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;; $Id$

(when (autoload-if-found 'riece "riece" nil t)
  (setq riece-server-alist
	'(("default"
	   :host "localhost"
	   :service 6667
	   :coding utf-8))
	riece-server "default"
	riece-ndcc-server-address "localhost"
	riece-channel-buffer-mode t
	riece-user-list-buffer-mode t
	riece-layout "middle-left"

	riece-preference-directory
	(expand-file-name "riece" base-directory)

	riece-addon-directory
	(expand-file-name "addons" riece-preference-directory)

	riece-saved-variables-file
	(expand-file-name "save" riece-preference-directory)

	riece-variables-file
	(expand-file-name "init" riece-preference-directory)

	riece-variables-files (list riece-variables-file
				    riece-saved-variables-file)

	riece-saved-forms '(riece-channel-buffer-mode
			    riece-others-buffer-mode
			    riece-user-list-buffer-mode
			    riece-channel-list-buffer-mode
			    riece-layout riece-addons)

	riece-addons '(riece-alias
		       riece-button
		       riece-ctcp riece-guess riece-highlight
		       riece-history riece-icon riece-keyword
		       riece-menu riece-skk-kakutei riece-unread
		       riece-url)

	riece-keywords '(("[Ee]lim" . 0)
			 ("[Ee]macs" . 0)))

  (let
      ((notify-sound-file (expand-file-name "~/sounds/notify.wav"))
       (notify-sound-player "mplayer"))

    (and (locate-executable notify-sound-player)
	 (file-exists-p notify-sound-file)
	 (add-hook 'riece-notify-keyword-functions
		   `(lambda (keyword)
		      (start-process keyword "*Messages*" ,notify-sound-player
				     (expand-file-name ,notify-sound-file))))))
  (add-hook 'riece-startup-hook
	    '(lambda ()
	       (define-key riece-command-mode-map [(control x) n]
		 'riece-command-enter-message-as-notice))))

