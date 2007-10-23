;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(setq gc-cons-threshold (* 32 1024 1024))

(setq system-time-locale "C")

;; font lock
(when (require 'font-lock nil t)
  (when (not (featurep 'xemacs))
    (global-font-lock-mode t)))

;; carbon emacs
(setq mac-pass-control-to-system nil)
(setq mac-pass-command-to-system nil)
(setq mac-option-modifier 'meta)

;; meadow and cygwin
;; based upon meadow-users-jp:3050 and
;; http://mechanics.civil.tohoku.ac.jp/soft/node45.html and
;; http://meadow.sourceforge.jp/cgi-bin/hiki.cgi?%B0%EC%C8%CC%C5%AA%A4%CA%BE%F0%CA%F3

(when (featurep 'meadow)
  (let
      ((my-shell-file-name nil))

    (dolist (e (list nil "zsh" "sh"))
      (unless my-shell-file-name
	(setq my-shell-file-name (locate-executable e))))

    (when my-shell-file-name
      (setq explicit-shell-file-name my-shell-file-name)
      (setq shell-file-name my-shell-file-name)
      (setq shell-command-switch "-c"))

    (add-hook 'shell-mode-hook
	      (lambda ()
		(set-buffer-process-coding-system 'undecided-dos 'sjis-unix)))

    ;; shell-modeでの補完 (for drive letter)
    (setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-"))


  (when (string-match "cygwin"
		      (shell-command-to-string "zsh --version"))

    (defadvice kill-new (after after-kill-new activate)
      (and (locate-executable "zsh")
	   (start-process
	    "normalization fof the contents of the clipboard."
	    "*Messages*" "zsh"
	    "-c" "cat =(cat /dev/clipboard) > /dev/clipboard")))))

;; Deleteキーでカーソル位置の文字が消えるようにする
(global-set-key [delete] 'delete-char)

;; C-h キーでカーソルの左の文字が消えるようにする
;; (global-set-key "\C-h" 'backward-delete-char)

;; C-h を C-? (Backspace) にする
(when (functionp 'keyboard-translate)
  (keyboard-translate ?\C-h ?\C-?))

;;補完時に大文字と小文字を区別させない
(setq completion-ignore-case t)

;; ヘルプ等の window を可変にする
(when (functionp 'temp-buffer-resize-mode)
  (temp-buffer-resize-mode t))

;; visible-bell
(setq visible-bell t)

;; 行番号を表示する
(when (functionp 'line-number-mode)
  (line-number-mode t))

;; 桁番号を表示する
(when (functionp 'column-number-mode)
  (column-number-mode t))

;;; 時刻を24時間制でモードラインに表示する
(when (functionp 'display-time)
  (setq display-time-24hr-format t)
  (display-time))

;; メニューを消す
(when (functionp 'menu-bar-mode)
  (menu-bar-mode -1))

;; ツールバーを消す
(when (functionp 'tool-bar-mode)
  (tool-bar-mode -1))

;;スクロールバーを右に
(when (functionp 'set-scroll-bar-mode)
  (set-scroll-bar-mode 'right))

;; スクロールバーを消す
(when (functionp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; window system では行間を空ける
(setq-default line-spacing 2)

;; バッファの最後で newline で新規行を追加するのを禁止する
(setq next-line-add-newlines nil)

;;対応する括弧を表示するか
(when (functionp 'show-paren-mode)
  (show-paren-mode -1))

;; フレームタイトルを 「バッファ名 (フルパスのファイル名)」とする
(setq frame-title-format
      `(" %b " (buffer-file-name "( %f )")))

;; 同一ファイル名のバッファ名を分かりやすく
(when (require 'uniquify nil t)
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
	uniquify-ignore-buffers-re "*[^*]+*"
	uniquify-min-dir-content 1))

;; minibuf-isearch
(require 'minibuf-isearch nil t)

;; grep-edit
(require 'grep-edit nil t)

;;kill-ring に同じ内容の文字列を複数入れない
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

;; history から重複したのを消す
(defun minibuffer-delete-duplicate ()
  (let (list)
    (dolist (elt (symbol-value minibuffer-history-variable))
      (unless (member elt list)
	(push elt list)))
      (set minibuffer-history-variable (nreverse list))))
(add-hook 'minibuffer-setup-hook 'minibuffer-delete-duplicate)

;; yank した文字列を X11 の cut buffer に送る
(setq x-select-enable-clipboard t)