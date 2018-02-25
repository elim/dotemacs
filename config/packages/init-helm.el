;;; init-helm.el --- A setting of the helm.
;;; Commentary:
;;; Code:

(use-package helm-config
  :after (helm-projectile)

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

  :custom
  (helm-input-idle-delay 0.3)
  (helm-candidate-number-limit 200)
  (helm-buffer-max-length 40)
  (helm-ff-auto-update-initial-value nil)

  (helm-mini-default-sources
   '(helm-source-buffers-list
     helm-source-recentf
     helm-source-projectile-recentf-list
     helm-source-projectile-buffers-list
     helm-source-projectile-files-list
     helm-source-projectile-projects
     helm-source-buffer-not-found))

  :demand t)

;;; init-helm.el ends here
