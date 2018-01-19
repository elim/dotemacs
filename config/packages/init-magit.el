;;; init-magit.el --- A setting of the magit.
;;; Commentary:
;;; Code:

(use-package magit
  :bind ("C-x v s" . magit-status)
  :init (add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8))
  :demand t)

;;; init-magit.el ends here
