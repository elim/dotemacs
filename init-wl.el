;-*- emcs-lisp -*-
;;����ʬ������
(autoload 'elmo-split "elmo-split" "Split messages on the folder." t)
; procmail �˥Хȥ󥿥å���

(setq wl-biff-check-folder-list '("%INBOX")
      wl-biff-check-interval 30
      wl-biff-notify-hook '(ding))

; ���ޥ���������ɽ������ե����
(setq wl-summary-showto-folder-regexp "^\\%INBOX.Sent$")
(setq wl-demo-background-color "#ccccff")

; emacs �� defualt MUA �ˡ�
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