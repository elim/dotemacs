;;; init-flycheck.el --- A setting of the flycheck.
;;; Commentary:
;;; Code:

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-checker-error-threshold 5000)
(setq flycheck-command-wrapper-function #'elim:flycheck-command-wrapper)

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

    (or replaced-command-list command-list)))

(provide 'init-flycheck)

;;; init-flycheck.el ends here
