;;; init-helm.el --- A setting of the helm.
;;; Commentary:
;;; Code:

(require 'helm-config)
(helm-mode 1)

(define-key global-map (kbd "M-x") 'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)

(define-key global-map (kbd "C-:") 'helm-mini)
(define-key global-map (kbd "C-;") 'helm-mini)
(define-key ctl-x-map  (kbd ":")   'helm-mini)
(define-key ctl-x-map  (kbd ";")   'helm-mini)
(define-key ctl-x-map  (kbd "C-:") 'helm-mini)
(define-key ctl-x-map  (kbd "C-;") 'helm-mini)

(define-key helm-map           (kbd "C-h") 'delete-backward-char)
(define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)

(define-key helm-read-file-map  (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

(define-key ctl-x-map  (kbd "C-y") 'helm-show-kill-ring)

(setq helm-idle-delay       0.3
      helm-input-idle-delay 0.3
      helm-candidate-number-limit 200
      helm-buffer-max-length       40
      helm-ff-auto-update-initial-value nil
      helm-mini-default-sources
      '(helm-source-buffers-list
        helm-source-recentf
        helm-source-projectile-recentf-list
        helm-source-projectile-buffers-list
        helm-source-projectile-files-list
        helm-source-projectile-projects
        helm-source-buffer-not-found))

(provide 'init-helm)
;;; init-helm.el ends here
