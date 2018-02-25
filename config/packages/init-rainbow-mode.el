;;; init-rainbow-mode.el --- A setting of the rainbow-mode.
;;; Commentary:
;;; Code:

(when (require 'rainbow-mode nil t)
  (add-hook 'css-mode-hook 'rainbow-mode)
  (add-hook 'scss-mode-hook 'rainbow-mode)
  (add-hook 'php-mode-hook 'rainbow-mode)
  (add-hook 'html-mode-hook 'rainbow-mode))

;;; init-rainbow-mode.el ends here
