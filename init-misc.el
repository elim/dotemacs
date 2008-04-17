;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(global-set-key [delete] #'delete-char)

(setq completion-ignore-case t
      display-time-24hr-format t
      enable-recursive-minibuffers nil
      frame-title-format `(" %b " (buffer-file-name "( %f )"))
      gc-cons-threshold (* 32 1024 1024)
      inhibit-splash-screen t
      kill-ring-max 300
      next-line-add-newlines nil
      system-time-locale "C"
      visible-bell t
      x-select-enable-clipboard t)

(setq-default line-spacing
	      (if (featurep 'mac-carbon) nil 2))

(mapc '(lambda (f)
	 (let ((func (car f)) (args (cdr f)))
	   (when (functionp func)
	     (apply func args))))
      '((line-number-mode t)
	(global-font-lock-mode t)
	(temp-buffer-resize-mode t)
	(keyboard-translate ?\C-h ?\C-?)
	(column-number-mode t)
	(display-time)
	(menu-bar-mode -1)
	(tool-bar-mode -1)
	(set-scroll-bar-mode 'right)
	(scroll-bar-mode -1)
	(show-paren-mode -1)))

;; 同一ファイル名のバッファ名を分かりやすく
(when (require 'uniquify nil t)
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
	uniquify-ignore-buffers-re "*[^*]+*"
	uniquify-min-dir-content 1))

;; minibuf-isearch
(require 'minibuf-isearch nil t)

;; http://www.emacsblog.org/2007/02/27/quick-tip-add-occur-to-isearch/
(define-key isearch-mode-map (kbd "C-o")
  (lambda ()
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string
	       (regexp-quote isearch-string))))))

;; grep-edit
(require 'grep-edit nil t)

;;kill-ring に同じ内容の文字列を複数入れない
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))
(setq-default minibuffer-setup-hook)

;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=delete%20history
(add-hook
 'minibuffer-setup-hook
 '(lambda ()
    (mapc
     '(lambda (arg)
	(set minibuffer-history-variable
	     (cons arg
		   (remove arg
			   (symbol-value minibuffer-history-variable)))))
     (reverse (symbol-value minibuffer-history-variable)))))
