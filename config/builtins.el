;;; builtins.el --- A setting of builtin modules.
;;; Commentary:
;;; Code:

;; Key settings

;; Enable mature methods
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(set-default 'indent-tabs-mode nil)
(set-default 'cursor-in-non-selected-windows nil)
(set-variable 'frame-title-format `(" %b " (buffer-file-name "( %f )")))
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

(use-package css-mode
  :mode "\\.css\\'"
  :custom (css-indent-offset 2))

(use-package dabbrev
  :custom (dabbrev-abbrev-skip-leading-regexp "\\$"))

(use-package desktop
  :custom (desktop-save-mode +1)
  :config
  (add-to-list 'desktop-globals-to-save 'extended-command-history)
  (add-to-list 'desktop-globals-to-save 'kill-ring)
  (add-to-list 'desktop-globals-to-save 'log-edit-comment-ring)
  (add-to-list 'desktop-globals-to-save 'read-expression-history))

(use-package eldoc
  :custom
  (eldoc-idle-delay 0.2)
  (eldoc-minor-mode-string "")
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
  :custom (insert-directory-program "gls"))

(use-package find-func
  :config
  ;; C-x F => Find Function
  ;; C-x V => Find Variable
  ;; C-x K => Find Function on Key
  (find-function-setup-keys))

(use-package flyspell
  :custom
  ;; M-TABのキーバインドを変更しない
  (flyspell-use-meta-tab nil)
  ;; スペルチェックには英語の辞書を使う
  (ispell-dictionary "american"))

(use-package font-core
  :config (global-font-lock-mode t))

(use-package help
  :config (temp-buffer-resize-mode t))

(use-package hl-line
  :config (global-hl-line-mode -1))

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
  :if (featurep 'ns)
  :custom
  (ns-pop-up-frames nil)
  (ns-antialias-text t)
  (ns-command-modifier 'meta)
  (ns-alternate-modifier 'meta))

(use-package select
  :custom (select-enable-primary t))

(use-package server
  :custom (server-window 'pop-to-buffer)
  :config
  (unless (server-running-p) (server-start))
  (remove-hook
   'kill-buffer-query-functions
   'server-kill-buffer-query-function))

(use-package sh-script
  :mode ("\\.env\\'" "\\.env.sample\\'")
  :custom
  (sh-basic-offset 2)
  (sh-indentation 2))

(use-package time
  :custom (display-time-24hr-format t)
  :config (display-time))

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'post-forward-angle-brackets)
  (uniquify-ignore-buffers-re "*[^*]+*")
  (uniquify-min-dir-content 1))

(use-package scroll-bar
  :config
  (column-number-mode +1)
  (set-scroll-bar-mode 'right)
  (scroll-bar-mode -1))

(use-package simple
  :hook (before-save . elim:auto-delete-trailing-whitespace)

  :custom
  (kill-ring-max 300)
  (line-move-visual t)

  :init
  (defvar elim:auto-delete-trailing-whitespace-enable-p t)

  :config
  (line-number-mode +1)
  (transient-mark-mode t)

  (advice-add 'kill-new :before #'elim:dedup-kill-new)

  (defun elim:dedup-kill-new (arg)
    (setq kill-ring (delete arg kill-ring)))

  (defun elim:editorconfig-mode-enabled-p ()
    (not (not (memq 'editorconfig-mode (mapcar #'car minor-mode-alist)))))

  (defun elim:auto-delete-trailing-whitespace ()
    (and elim:auto-delete-trailing-whitespace-enable-p
         (not (elim:editorconfig-mode-enabled-p))
         (delete-trailing-whitespace))))

(use-package tool-bar
  :hook (window-setup . elim:disable-tool-bar)
  :config
  (defun elim:disable-tool-bar () (tool-bar-mode -1)))

;;; builtins.el ends here
