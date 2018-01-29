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
    (let*
        ((wrapper-alist '((rubocop   . ("bundle" "exec"))
                          (slim-lint . ("bundle" "exec"))
                          (scss-lint . ("bundle" "exec"))
                          (stylelint . ("npx"))))
         (executable (car command-list))
         (wrapper (cdr (assq (intern executable) wrapper-alist))))

      (append wrapper command-list))))

;;; init-flycheck.el ends here
