;;; init-magit.el --- A setting of the magit.
;;; Commentary:
;;; Code:

(global-set-key (kbd "C-x v s") 'magit-status)
(add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8))

(provide 'init-magit)

;;; init-magit.el ends here
