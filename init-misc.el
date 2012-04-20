;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;;;試行錯誤用ファイルを開くための設定
;; (auto-install-from-emacswiki "open-junk-file.el")
(when (require 'open-junk-file nil t)
  (global-set-key (kbd "C-x C-z") 'open-junk-file))

;;;式の評価結果を注釈するための設定
;; (auto-install-from-emacswiki "lispxmp.el")
(when (require 'lispxmp nil t)
  (define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp))

;; (when (require 'paredit nil t)
;;   (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
;;   (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
;;   (add-hook 'lisp-mode-hook 'enable-paredit-mode)
;;   (add-hook 'ielm-mode-hook 'enable-paredit-mode))

;; (auto-install-from-emacswiki "auto-async-byte-compile.el")
(when (require 'auto-async-byte-compile nil t)
  (setq auto-async-byte-compile-exclude-files-regexp "/junk/")
  (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode))

(when (require 'eldoc nil t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
  (setq eldoc-idle-delay 0.2)
  (setq eldoc-minor-mode-string ""))

;;改行と同時にインデントも行う
;; (global-set-key "\C-m" 'newline)
;; (global-set-key "\C-m" 'newline-and-indent)

;; find-functionをキー割り当てする
(find-function-setup-keys)


(global-set-key [delete] #'delete-char)

(setq-default
 completion-ignore-case t
 display-time-24hr-format t
 enable-recursive-minibuffers nil
 frame-title-format `(" %b " (buffer-file-name "( %f )"))
 gc-cons-threshold (* 64 1024 1024)
 indent-tabs-mode nil
 inhibit-startup-screen t
 kill-ring-max 300
 line-move-visual nil
 next-line-add-newlines nil
 read-buffer-completion-ignore-case t
 read-file-name-completion-ignore-case t
 system-time-locale "C"
 tab-width 2
 visible-bell t
 x-select-enable-clipboard t)

(line-number-mode t)
(global-font-lock-mode t)
(temp-buffer-resize-mode t)
(keyboard-translate ?\C-h ?\C-?)
(column-number-mode t)
(display-time)
(menu-bar-mode (if (or (eq window-system 'ns)
                       (eq window-system 'mac)) 1 -1))
(transient-mark-mode t)
(when (boundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (boundp 'scroll-bar-mode)
  (set-scroll-bar-mode 'right)
  (scroll-bar-mode -1))

(add-hook 'after-save-hook
          (lambda ()
            (unless (and (boundp 'tramp-file-name-regexp)
                         (string-match tramp-file-name-regexp (buffer-file-name)))
              (executable-make-buffer-file-executable-if-script-p))))



(when (require 'open-junk-file) nil t
      (global-set-key (kbd "C-x C-z") 'open-junk-file))


;; 同一ファイル名のバッファ名を分かりやすく
(when (require 'uniquify nil t)
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
        uniquify-ignore-buffers-re "*[^*]+*"
        uniquify-min-dir-content 1))

;; http://www.emacsblog.org/2007/02/27/quick-tip-add-occur-to-isearch/
(define-key isearch-mode-map (kbd "C-o")
  (lambda ()
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string
               (regexp-quote isearch-string))))))

;; grep-edit
(require 'grep-edit nil t)

;; 行末の空白をめだたせる M-x delete-trailing-whitespaceで削除出来る
(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t))

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
