;;; init-rainbow-mode.el --- A setting of the rainbow-mode.
;;; Commentary:
;;; Code:

(use-package rainbow-mode
  :hook
  (css-mode  . rainbow-mode)
  (css-mode  . rainbow-mode)
  (scss-mode . rainbow-mode)
  (php-mode  . rainbow-mode)
  (html-mode . rainbow-mode))

;;; init-rainbow-mode.el ends here
