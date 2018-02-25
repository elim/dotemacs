;;; init-helm-ag.el --- A setting of the helm-ag.
;;; Commentary:
;;; Code:

(use-package helm-ag
  :bind ("C-x g" . helm-projectile-ag)

  :custom
  (helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
  (helm-ag-command-option "--all-text")
  (helm-ag-insert-at-point 'symbol))

;;; init-helm-ag.el ends here
