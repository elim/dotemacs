;-*- emacs-lisp -*-
;$Id$;

(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; vars
(setq wl-auto-save-drafts-interval 30)
(setq wl-draft-use-frame nil)

;; 振り分け準備 ( procmail にバトンタッチ)
;;(autoload 'elmo-split "elmo-split" "Split messages on the folder." t)

;;自動着信確認
(setq wl-biff-check-folder-list '("%INBOX")
      wl-biff-check-interval 30
      wl-biff-notify-hook '(ding))

;; サマリで送り先を表示するフォルダ
(setq wl-summary-showto-folder-regexp "^\\%INBOX.Sent$")

(setq wl-demo-background-color "#ccccff")

;; emacs の defualt MUA に。
(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-sen
      'wl-draft-kill
      'mail-send-hook))