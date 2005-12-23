;-*- emacs-lisp -*-
;$Id$;

(when (autoload-if-found 'wl "wl" "Wanderlust" t)
  (autoload-if-found 'wl-other-frame "wl" "Wanderlust on new frame." t)
  (autoload-if-found 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

  (setq wl-summary-showto-folder-regexp "^\\%Sent$")
  (setq wl-demo-background-color "#ccccff")
  (setq wl-auto-save-drafts-interval 30)
  (setq wl-draft-use-frame nil)

  (setq wl-biff-check-folder-list '("%INBOX"))
  (setq wl-biff-check-interval 30)
  (setq wl-biff-notify-hook '(ding))

;; 振り分け準備 ( procmail にバトンタッチ)
;(autoload 'elmo-split "elmo-split"
;  "Split messages on the folder." t)

;; emacs の defualt MUA に
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