;;; init-flycheck.el --- A setting of the flycheck.
;;; Commentary:
;;; Code:

(use-package flycheck
  :hook (after-init . global-flycheck-mode)

  :custom
  (flycheck-checker-error-threshold 5000)

  :init
  (add-to-list 'exec-path (expand-file-name "bin" user-emacs-directory)))

;;; init-flycheck.el ends here
