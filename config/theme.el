(add-to-list 'custom-theme-load-path
             (expand-file-name "config/theme" user-emacs-directory))

(defun elim:apply-theme()
  (load-theme 'cake t)
  (enable-theme 'cake))

(add-hook 'window-setup-hook #'elim:apply-theme)
