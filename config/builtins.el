;;; builtins.el --- A setting of builtin modules.
;;; Commentary:
;;; Code:

;; Key settings
(keyboard-translate ?\C-h ?\C-?)

(bind-keys :map global-map
           ("<ns-drag-file>" . ns-find-file)

           ("<delete>" . delete-char)
           ("C-h"      . delete-char)
           ("C-m"      . newline-and-indent)

           ("C-x |" . split-window-right)
           ("C-x -" . split-window-below))

;; Enable mature methods
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(set-variable 'cursor-in-non-selected-windows nil)
(set-variable 'frame-title-format `(" %b " (buffer-file-name "( %f )")))
(set-variable 'indent-tabs-mode nil)
(set-variable 'inhibit-startup-screen t)
(set-variable 'read-buffer-completion-ignore-case t)
(set-variable 'read-file-name-completion-ignore-case t)
(set-variable 'require-final-newline t)
(set-variable 'ring-bell-function 'ignore)
(set-variable 'scroll-conservatively 1)
(set-variable 'select-active-regions nil)
(set-variable 'show-trailing-whitespace nil)
(set-variable 'truncate-lines nil)
(set-variable 'visible-bell t)

(use-package browse-url
  :bind ("C-x m" . browse-url-at-point))

(use-package bs
  :bind ("C-x C-b" . bs-show))

(use-package css-mode
  :mode "\\.css\\'"
  :init (set-variable 'css-indent-offset 2))

(use-package dabbrev
  :init
  (set-variable 'dabbrev-abbrev-skip-leading-regexp "\\$"))

(use-package desktop
  :init
  (set-variable 'desktop-save-mode +1)
  :config
  (add-to-list 'desktop-globals-to-save 'extended-command-history)
  (add-to-list 'desktop-globals-to-save 'kill-ring)
  (add-to-list 'desktop-globals-to-save 'log-edit-comment-ring))

(use-package eldoc
  :init
  (set-variable 'eldoc-idle-delay 0.2)
  (set-variable 'eldoc-minor-mode-string "")
  :hook
  ((emacs-lisp-mode . turn-on-eldoc-mode)
   (lisp-interaction-mode . turn-on-eldoc-mode)
   (ielm-mode-hook . turn-on-eldoc-mode)))

(use-package executable
  :hook (after-save . elim:executable-make-buffer-file-executable-if-script-p)
  :config
  (defun elim:executable-make-buffer-file-executable-if-script-p ()
    (unless (string-match tramp-file-name-regexp (buffer-file-name))
      (executable-make-buffer-file-executable-if-script-p))))

(use-package files
  :if (executable-find "gls")
  :init (set-variable 'insert-directory-program "gls"))

(use-package find-func
  :config
  ;; C-x F => Find Function
  ;; C-x V => Find Variable
  ;; C-x K => Find Function on Key
  (find-function-setup-keys))

(use-package flyspell
  :init
  ;; M-TABのキーバインドを変更しない
  (set-variable 'flyspell-use-meta-tab nil)
  ;; デフォルトで自動スペルチェック機能を有効にする
  (set-variable 'flyspell-mode t)
  ;; スペルチェックには英語の辞書を使う
  (set-variable 'ispell-dictionary "american"))

(use-package font-core
  :config (global-font-lock-mode t))

(use-package help
  :config (temp-buffer-resize-mode t))

(use-package hideshow
  :bind (:map hs-minor-mode-map
              ("C-c C-M-c" . hs-toggle-hiding)
              ("C-c h"     . hs-toggle-hiding)
              ("C-c l"     . hs-hide-level)))

(use-package hl-line
  :config (global-hl-line-mode 1))

(use-package isearch
  :bind (:map isearch-mode-map
              ("C-o" . elim:occur-in-isearch))
  :config
  ;; Quick Tip: Add occur to isearch
  ;; http://www.emacsblog.org/2007/02/27/quick-tip-add-occur-to-isearch/
  (defun elim:occur-in-isearch ()
    "Call the occur function during an incremental search."
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string
               (regexp-quote isearch-string))))))

(use-package menu-bar
  :config (menu-bar-mode +1))

(use-package ns-win
  :init
  (set-variable 'ns-pop-up-frames nil)
  (set-variable 'ns-antialias-text t)
  (set-variable 'ns-command-modifier 'meta)
  (set-variable 'ns-alternate-modifier 'meta))

(use-package select
  :init
  (set-variable 'select-enable-primary t))

(use-package server
  :init
  (set-variable 'server-window 'pop-to-buffer)
  :config
  (unless (server-running-p) (server-start))
  (remove-hook
   'kill-buffer-query-functions
   'server-kill-buffer-query-function))

(use-package sh-script
  :mode ("\\.env\\'" "\\.env.sample\\'")
  :init
  (set-variable 'sh-basic-offset 2)
  (set-variable 'sh-indentation 2))

(use-package time
  :init (set-variable 'display-time-24hr-format t)
  :config (display-time))

(use-package uniquify
  :init
  (set-variable 'uniquify-buffer-name-style 'post-forward-angle-brackets)
  (set-variable 'uniquify-ignore-buffers-re "*[^*]+*")
  (set-variable 'uniquify-min-dir-content 1))

(use-package scroll-bar
  :config
  (column-number-mode +1)
  (set-scroll-bar-mode 'right)
  (scroll-bar-mode -1))

(use-package simple
  :hook (before-save . elim:auto-delete-trailing-whitespace)

  :init
  (set-variable 'kill-ring-max 300)
  (set-variable 'line-move-visual t)
  (defvar elim:auto-delete-trailing-whitespace-enable-p t)

  :config
  (line-number-mode +1)
  (transient-mark-mode t)

  (advice-add 'kill-new :before #'elim:dedup-kill-new)
  (defun elim:dedup-kill-new (arg)
    (setq kill-ring (delete arg kill-ring)))

  (defun elim:auto-delete-trailing-whitespace ()
    (and elim:auto-delete-trailing-whitespace-enable-p
         (delete-trailing-whitespace))))

(use-package tool-bar
  :hook (window-setup . elim:disable-tool-bar)
  :config
  (defun elim:disable-tool-bar () (tool-bar-mode -1)))

(load "builtins/align")
(load "builtins/cc-mode")
(load "builtins/dictionary")
(load "builtins/diff-mode")
(load "builtins/dired")
(load "builtins/paren")
(load "builtins/text-mode")

;;; builtins.el ends here
