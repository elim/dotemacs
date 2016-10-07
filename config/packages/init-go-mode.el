;;; init-go-mode.el --- A setting of the go-mode.
;;; Commentary:
;;; Code:

(with-eval-after-load-feature 'go-mode

  (defun elim:go-mode-hook-func ()
    (setq tab-width 4))

  (add-hook 'go-mode-hook #'elim:go-mode-hook-func))

(provide 'init-go-mode)

;;; init-go-mode.el ends here
