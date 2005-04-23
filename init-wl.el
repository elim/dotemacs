;-*- emcs-lisp -*-
;-*- encoding: iso-2022-jp -*-
;$Id$;
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;;$B?6$jJ,$1=`Hw(B
(autoload 'elmo-split "elmo-split" "Split messages on the folder." t)
; procmail $B$K%P%H%s%?%C%A!#(B

(setq wl-biff-check-folder-list '("%INBOX")
      wl-biff-check-interval 30
      wl-biff-notify-hook '(ding))

; $B%5%^%j$GAw$j@h$rI=<($9$k%U%)%k%@(B
(setq wl-summary-showto-folder-regexp "^\\%INBOX.Sent$")
(setq wl-demo-background-color "#ccccff")

; emacs $B$N(B defualt MUA $B$K!#(B
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