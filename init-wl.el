;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$;

(when (locate-library "wl")
  (autoload-if-found 'wl "wl" "Wanderlust" t)
  (autoload-if-found 'wl-other-frame "wl" "Wanderlust on new frame." t)
  (autoload-if-found 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

  (when (and window-system
	     (locate-library "x-face-e21")
	     (locate-executable "compface"))
    (autoload 'x-face-decode-message-header "x-face-e21" t)
    (setq wl-highlight-x-face-function 'x-face-decode-message-header))

  (setq wl-preference-directory (expand-file-name "wl" base-directory))
  (setq wl-init-file (expand-file-name "init.el" wl-preference-directory))
  (setq wl-address-file (expand-file-name "addresses" wl-preference-directory))
  (setq wl-folders-file (expand-file-name "folders" wl-preference-directory))

  (setq wl-summary-showto-folder-regexp "^\\%\\(Sent\\|Draft\\).*$"
	wl-summary-weekday-name-lang 'en
	wl-demo-background-color "#ccccff"
	wl-auto-save-drafts-interval 30
	wl-draft-use-frame nil
	wl-biff-check-folder-list '("%INBOX")
	wl-biff-check-interval 30
	wl-biff-notify-hook '(ding))

  (add-hook
   'wl-draft-mode-hook
   '(lambda ()
      (mapc (lambda (pair)
	      (apply #'define-key wl-draft-mode-map pair))
	    (list
	     '([(control l)] nil)
	     '([(control c) (l)] wl-draft-highlight-and-recenter)
	     '([(control c) (control l)] wl-draft-highlight-and-recenter)))))

  (defadvice wl-summary-line-day-of-week
    (after after-wl-summary-line-day-of-week activate)
    (when (string-match ad-return-value "?")
      (setq ad-return-value
	    (let
		((elmo-lang wl-summary-weekday-name-lang)
		 (day-of-week-name-width
		  (string-width (elmo-date-get-week 1970 1 1))))
	      (setq ad-return-value
		    (make-string day-of-week-name-width ??))))))

;;;  emacs の defualt MUA に
  (autoload-if-found 'wl-user-agent-compose "wl-draft" nil t)
  (if (boundp 'mail-user-agent)
      (setq mail-user-agent 'wl-user-agent))
  (if (fboundp 'define-mail-user-agent)
      (define-mail-user-agent
	'wl-user-agent
	'wl-user-agent-compose
	'wl-draft-sen
	'wl-draft-kill
	'mail-send-hook)))