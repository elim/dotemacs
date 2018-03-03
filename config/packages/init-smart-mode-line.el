;;; init-smart-mode-line.el --- A setting of the smart-mode-line.
;;; Commentary:
;;; Code:

(use-package smart-mode-line
  :custom
  (sml/no-confirm-load-theme t)
  (sml/theme 'respectful)

  :config
  (sml/setup))

;;; init-smart-mode-line.el ends here
