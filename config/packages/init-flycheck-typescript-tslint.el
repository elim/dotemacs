;;; init-flycheck-typescript-tslint.el --- A setting of the flycheck-typescript-tslint.
;;; Commentary:
;;; Code:

(load-library "flycheck-typescript-tslint")

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-typescript-tslint-setup))

(provide 'init-flycheck-typescript-tslint)

;;; init-flycheck-typescript-tslint.el ends here
