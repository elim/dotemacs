;;; init-magit.el --- A setting of the magit.
;;; Commentary:
;;; Code:

(use-package magit
  :bind ("C-x v s" . magit-status)
  :hook (git-commit-setup . elim:git-commit-setup-hook-func)
  :init (add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8))
  :config
  (defun elim:git-commit-setup-hook-func ()
    (set (make-local-variable
          'elim:auto-delete-trailing-whitespace-enable-p) nil))
  :demand t)

;;; init-magit.el ends here
