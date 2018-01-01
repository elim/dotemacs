;;; init-helm.el --- A setting of the helm.
;;; Commentary:
;;; Code:

(use-package helm-config
  :bind (("M-x"     . helm-M-x)
         ("C-:"     . helm-mini)
         ("C-;"     . helm-mini)
         ("C-x :"   . helm-mini)
         ("C-x ;"   . helm-mini)
         ("C-x C-:" . helm-mini)
         ("C-x C-;" . helm-mini)
         ("C-x C-y" . helm-show-kill-ring)
         ("C-x C-f" . helm-find-files)
         :map helm-map
         ("C-h" . delete-backward-char)
         :map helm-find-files-map
         ("TAB" . helm-execute-persistent-action)
         :map helm-read-file-map
         ("C-h" . delete-backward-char)
         ("TAB" . helm-execute-persistent-action))
  :config
  (helm-mode 1)
  (set-variable 'helm-input-idle-delay 0.3)
  (set-variable 'helm-candidate-number-limit 200)
  (set-variable 'helm-buffer-max-length 40)
  (set-variable 'helm-ff-auto-update-initial-value nil)

  (set-variable 'helm-mini-default-sources
                '(helm-source-buffers-list
                  helm-source-recentf
                  helm-source-projectile-recentf-list
                  helm-source-projectile-buffers-list
                  helm-source-projectile-files-list
                  helm-source-projectile-projects
                  helm-source-buffer-not-found)))

(provide 'init-helm)
;;; init-helm.el ends here
