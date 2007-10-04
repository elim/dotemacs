;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (autoload-if-found 'riece "riece" nil t)
  (setq riece-server-alist
	'(("idea" :host "idea")
	  ("localhost" :host "localhost")))
  (setq riece-server
	(if (domestic-network-member-p)
	    "idea"
	  "localhost"))
  (setq riece-channel-buffer-mode 't)
  (setq riece-user-list-buffer-mode 't)
  (setq riece-layout '"middle-left")

  (setq riece-directory
	(expand-file-name "riece" my-lisp-path))
  (setq riece-addon-directory
	(expand-file-name "addons" my-lisp-path))
  (setq riece-saved-variables-file
	(expand-file-name "save" riece-directory))
  (setq riece-variables-file
	(expand-file-name "init" riece-directory))

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

  (let
      ((my-notify-sound-file (expand-file-name "~/sounds/notify.wav"))
       (my-notify-sound-player "mplayer"))
    
    (when (and (locate-library my-notify-sound-player nil exec-path)
	       (file-exists-p my-notify-sound-file))
      
       (add-hook 'riece-notify-keyword-functions
		 `(lambda (keyword)
		    (start-process keyword "*Messages*" ,my-notify-sound-player
				   (expand-file-name ,my-notify-sound-file))))))

  (add-hook 'riece-startup-hook
	    (lambda ()
	      (define-key riece-command-mode-map "\C-xn"
		'riece-command-enter-message-as-notice))))