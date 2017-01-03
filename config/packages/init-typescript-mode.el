;;; init-typescript-mode.el --- A setting of the typescript-mode.
;;; Commentary:
;;; Code:


(defun elim:typescript-mode-hook-func ()
  (tide-setup)
  (flycheck-mode t)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode t)
  (company-mode-on))

(add-hook 'typescript-mode-hook #'elim:typescript-mode-hook-func)

(provide 'init-typescript-mode)

;;; init-typescript-mode.el ends here
