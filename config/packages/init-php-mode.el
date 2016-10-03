;;; init-php-mode.el --- A setting of the php-mode.
;;; Commentary:
;;; Code:

(with-eval-after-load-feature 'php-mode
  (add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

  (defun elim:php-mode-hook-func ()
    (define-key php-mode-map (kbd "C-c C-[") 'beginning-of-defun)
    (define-key php-mode-map (kbd "C-c C-]") 'end-of-defun)

    (setq-local shell-file-name "/bin/sh")
    (setq flycheck-phpcs-standard "PSR2")
    (setq php-mode-coding-style (quote PSR-2))
    (php-enable-psr2-coding-style)
    (hs-minor-mode 1))

  (add-hook 'php-mode-hook #'elim:php-mode-hook-func))

(provide 'init-php-mode)

;;; init-php-mode.el ends here
