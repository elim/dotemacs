;-*- emcs-lisp -*-
;;振り分け準備
(autoload 'elmo-split "elmo-split" "Split messages on the folder." t)
; procmail にバトンタッチ。

(setq wl-biff-check-folder-list '("%INBOX")
      wl-biff-check-interval 30
      wl-biff-notify-hook '(ding))

; サマリで送り先を表示するフォルダ
(setq wl-summary-showto-folder-regexp "^\\%INBOX.Sent$")
(setq wl-demo-background-color "#ccccff")

; emacs の defualt MUA に。
;(autoload 'wl-user-agent-compose "wl-draft" nil t)
;(if (boundp 'mail-user-agent)
;    (setq mail-user-agent 'wl-user-agent))
;(if (fboundp 'define-mail-user-agent)
;    (define-mail-user-agent
;      'wl-user-agent
;      'wl-user-agent-compose
;      'wl-draft-send
;      'wl-draft-kill
;      'mail-send-hook))