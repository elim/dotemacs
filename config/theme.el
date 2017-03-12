(add-to-list 'custom-theme-load-path
             (expand-file-name "config/theme" user-emacs-directory))

(defun elim:apply-theme()
  (let
      ((theme (if window-system
                  'cake
                'tango-dark)))
    (load-theme theme t)
  (enable-theme theme)))

(add-hook 'window-setup-hook #'elim:apply-theme)
