;;; init-helm-projectile.el --- A setting of the helm-projectile.
;;; Commentary:
;;; Code:

(use-package helm-projectile
  :bind ("M-t" . helm-projectile)
  :config (helm-projectile-on)
  :demand t)

;;; init-helm-projectile.el ends here
