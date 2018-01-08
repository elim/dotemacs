;;; init-helm-projectile.el --- A setting of the helm-projectile.
;;; Commentary:
;;; Code:

(use-package helm-projectile
  :bind ("M-t" . helm-projectile)
  :init (set-variable 'projectile-enable-caching t)
  :config
  (with-eval-after-load 'helm
    (message "loaded helm"
    (projectile-global-mode t)
    (helm-projectile-on))))

;;; init-helm-projectile.el ends here
