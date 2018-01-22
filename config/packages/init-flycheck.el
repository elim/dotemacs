;;; init-flycheck.el --- A setting of the flycheck.
;;; Commentary:
;;; Code:

(use-package flycheck
  :hook (after-init . global-flycheck-mode)

  :custom
  (flycheck-checker-error-threshold 5000)
  (flycheck-command-wrapper-function #'elim:flycheck-command-wrapper)

  :config
  (defun elim:flycheck-command-wrapper (command-list)
    (let
        ((bundled-executables (list "rubocop" "slim-lint" "scss-lint"))
         (executable (car command-list))
         (arguments (cdr command-list))
         (replaced-command-list))

      (dolist (bundled-executable bundled-executables)
        (when (string-match bundled-executable executable)
          (setq replaced-command-list
                (append (list "bundle" "exec" bundled-executable) arguments))))

      (or replaced-command-list command-list))))

;;; init-flycheck.el ends here
