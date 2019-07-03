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
