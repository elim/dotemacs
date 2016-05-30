;;; init-auto-complete.el --- A setting of the auto-complete.
;;; Commentary:
;;; Code:

(when (require 'auto-complete nil t)

  (defun elim:auto-complete-mode-hook-func ()
    (define-key ac-completing-map (kbd "C-n") 'ac-next)
    (define-key ac-completing-map (kbd "C-p") 'ac-previous))

  (global-auto-complete-mode t)
  (add-hook 'auto-complete-mode-hook #'elim:auto-complete-mode-hook-func))

(provide 'init-auto-complete)

;;; init-auto-complete.el ends here
