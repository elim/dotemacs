;-*- emcs-lisp -*-
;
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;;振り分け準備
(autoload 'elmo-split "elmo-split" "Split messages on the folder." t)
; procmail にバトンタッチ。

(setq wl-biff-check-folder-list '("%INBOX")
      wl-biff-check-interval 30
      wl-biff-notify-hook '(ding))

; サマリで送り先を表示するフォルダ
(setq wl-summary-showto-folder-regexp "^\\%INBOX.Sent$")
(setq wl-demo-background-color "#ccccff")


(eval-after-load
    "mime-edit"
  '(let ((text (assoc "text" mime-content-types)))
     (set-alist 'text "plain"
                '(("charset" "" "ISO-2022-JP" "US-ASCII"
                   "ISO-8859-1" "ISO-8859-8" "UTF-8")))
     (set-alist 'mime-content-types "text" (cdr text))))

; emacs の defualt MUA に。
;(autoload 'wl-user-agent-compose "wl-draft" nil t)
;; (if (boundp 'mail-user-agent)
;;     (setq mail-user-agent 'wl-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;;     (define-mail-user-agent
;;       'wl-user-agent
;;       'wl-user-agent-compose
;;       'wl-draft-sen
;;       'wl-draft-kill
;;       'mail-send-hook))