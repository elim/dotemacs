;;; init-helm-projectile.el --- A setting of the helm-projectile.
;;; Commentary:
;;; Code:

(require 'helm-projectile )
(helm-projectile-on)
(global-set-key (kbd "M-t") 'helm-projectile)

(provide 'init-helm-projectile)
;;; init-helm-projectile.el ends here
