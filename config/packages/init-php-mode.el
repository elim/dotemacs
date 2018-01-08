;;; init-php-mode.el --- A setting of the php-mode.
;;; Commentary:
;;; Code:

(use-package php-mode
  :bind (:map php-mode-map
              ("C-c C-[" . beginning-of-defun)
              ("C-c C-]" . end-of-defun))

  :custom (php-mode-coding-style 'psr2)

  :config
  (defun elim:php-mode-hook-func ()
    (setq-local shell-file-name "/bin/sh")
    (setq-local flycheck-phpcs-standard "PSR2")
    (php-enable-psr2-coding-style)
    (hs-minor-mode 1))

  :hook (php-mode-hook . elim:php-mode-hook-func))

(provide 'init-php-mode)

;;; init-php-mode.el ends here
