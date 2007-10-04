;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$;

(when (locate-library "wl")
  (autoload 'wl "wl" "Wanderlust" t)
  (autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
  (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

  (when (and window-system
	     (locate-library "x-face-e21")
	     (locate-library "compface" nil exec-path))
    (autoload 'x-face-decode-message-header "x-face-e21" t)
    (setq wl-highlight-x-face-function 'x-face-decode-message-header))

  (setq my-wl-path (expand-file-name "wl" my-lisp-path))
  (setq wl-init-file (expand-file-name "init.el" my-wl-path))
  (setq wl-address-file (expand-file-name "addresses" my-wl-path))
  (setq wl-folders-file (expand-file-name "folders" my-wl-path))

  (setq wl-summary-showto-folder-regexp "^\\%\\(Sent\\|Draft\\).*$")
  (setq wl-summary-weekday-name-lang 'en)
  (setq wl-demo-background-color "#ccccff")
  (setq wl-auto-save-drafts-interval 30)
  (setq wl-draft-use-frame nil)

  (setq wl-biff-check-folder-list '("%INBOX"))
  (setq wl-biff-check-interval 30)
  (setq wl-biff-notify-hook '(ding))

  (defadvice wl-summary-line-day-of-week
    (after after-wl-summary-line-day-of-week)
    (when (string-match ad-return-value "?")
      (setq ad-return-value
	    (let*
		((elmo-lang wl-summary-weekday-name-lang)
		 (day-of-week-name-width
		  (string-width (elmo-date-get-week 1970 1 1)))
		 (return-string ""))
	      (dotimes (r day-of-week-name-width return-string)
		(setq return-string (concat "?" return-string)))))))

  (ad-activate 'wl-summary-line-day-of-week)

;;; 振り分け準備 (procmail にバトンタッチ)
;;  (autoload 'elmo-split "elmo-split"
;;    "Split messages on the folder." t)

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