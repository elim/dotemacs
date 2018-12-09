;;; init-projectile.el --- A setting of the projectile.
;;; Commentary:
;;; Code:

(use-package projectile
  :config (projectile-global-mode t)
  :custom (projectile-enable-caching t)
  :delight '(:eval (concat " [" (projectile-project-name) "]")))

;;; init-projectile.el ends here
