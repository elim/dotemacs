;;; init-flycheck-typescript-tslint.el --- A setting of the flycheck-typescript-tslint.
;;; Commentary:
;;; Code:

(load-library "flycheck-typescript-tslint")

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-typescript-tslint-setup))

;;; init-flycheck-typescript-tslint.el ends here
