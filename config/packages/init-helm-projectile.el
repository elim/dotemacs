;;; init-helm-projectile.el --- A setting of the helm-projectile.
;;; Commentary:
;;; Code:

(use-package helm-projectile
  :bind ("M-t" . helm-projectile)
  :config
  (projectile-global-mode t)
  (helm-projectile-on)
  :custom (projectile-enable-caching t)
  :demand t)

;;; init-helm-projectile.el ends here
