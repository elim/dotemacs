;;; init-flycheck.el --- A setting of the flycheck.
;;; Commentary:
;;; Code:

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-checker-error-threshold 5000)

(provide 'init-flycheck)

;;; init-flycheck.el ends here
