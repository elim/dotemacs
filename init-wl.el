;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$;

(when (locate-library "wl")
  (autoload 'wl "wl" "Wanderlust" t)
  (autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
  (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

  (when (locate-library "x-face-e21")
    (autoload 'x-face-decode-message-header "x-face-e21" t)
    (setq wl-highlight-x-face-function 'x-face-decode-message-header))

  (setq my-wl-path (expand-file-name (concat my-lisp-path "/wl")))
  (setq wl-init-file (expand-file-name (concat my-wl-path "/init.el")))
  (setq wl-address-file (expand-file-name (concat my-wl-path "/addresses")))
  (setq wl-folders-file (expand-file-name (concat my-wl-path "/folders")))

  (setq wl-summary-showto-folder-regexp "^\\%Sent$")
  (setq wl-demo-background-color "#ccccff")
  (setq wl-auto-save-drafts-interval 30)
  (setq wl-draft-use-frame nil)

  (setq wl-biff-check-folder-list '("%INBOX"))
  (setq wl-biff-check-interval 30)
  (setq wl-biff-notify-hook '(ding))

;;(setq signature-file-name "~/.signature")

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