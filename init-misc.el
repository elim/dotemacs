;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(setq gc-cons-threshold (* 32 1024 1024))

(setq system-time-locale "C")

(setq kill-ring-max 300)

;; font lock
(when (and (require 'font-lock nil t)
	   (not (featurep 'xemacs)))
  (global-font-lock-mode t))

(global-set-key [delete] #'delete-char)

(when (functionp #'keyboard-translate)
  (keyboard-translate ?\C-h ?\C-?))

(setq completion-ignore-case t)

;; ヘルプ等の window を可変にする
(when (functionp #'temp-buffer-resize-mode)
  (temp-buffer-resize-mode t))

(setq visible-bell t)

(when (functionp #'line-number-mode)
  (line-number-mode t))

(when (functionp #'column-number-mode)
  (column-number-mode t))

(when (functionp #'display-time)
  (setq display-time-24hr-format t)
  (display-time))

(when (functionp #'menu-bar-mode)
  (menu-bar-mode -1))

(when (functionp #'tool-bar-mode)
  (tool-bar-mode -1))

(when (functionp #'set-scroll-bar-mode)
  (set-scroll-bar-mode 'right))

(when (functionp #'scroll-bar-mode)
  (scroll-bar-mode -1))

(unless (featurep 'mac-carbon)
  (setq-default line-spacing 2))

;; バッファの最後で newline で新規行を追加するのを禁止する
(setq next-line-add-newlines nil)

;;対応する括弧を表示するか
(when (functionp #'show-paren-mode)
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

;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=delete%20history
(add-hook
 'minibuffer-setup-hook
 #'(lambda ()
     (mapc
      #'(lambda (arg)
	  (set minibuffer-history-variable
	       (cons arg
		     (remove arg
			     (symbol-value minibuffer-history-variable)))))
      (reverse (symbol-value minibuffer-history-variable)))))

;; yank した文字列を X11 の cut buffer に送る
(setq x-select-enable-clipboard t)

(when (load "saveplace" 'noerror)
  (setq-default save-place t))
