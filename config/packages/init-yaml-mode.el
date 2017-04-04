;;; init-yaml-mode.el --- A setting of the yaml-mode.
;;; Commentary:
;;; Code:

(define-derived-mode saltstack-mode yaml-mode "Saltstack"
  "Minimal Saltstack mode, based on `yaml-mode'."
  (setq tab-width 2
        indent-tabs-mode nil))

(add-to-list 'auto-mode-alist '("\\.sls\\'"   . saltstack-mode))
(add-to-list 'auto-mode-alist '("\\master\\'" . saltstack-mode))
(add-to-list 'auto-mode-alist '("\\roster\\'" . saltstack-mode))

(provide 'init-yaml-mode)

;;; init-yaml-mode.el ends here
