;;; init-salt-mode.el --- A setting of the salt-mode.
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.sls\\'"     . salt-mode))
(add-to-list 'auto-mode-alist '("\\master\\'"   . salt-mode))
(add-to-list 'auto-mode-alist '("\\roster\\'"   . salt-mode))
(add-to-list 'auto-mode-alist '("\\Saltfile\\'" . salt-mode))

;;; init-salt-mode.el ends here
