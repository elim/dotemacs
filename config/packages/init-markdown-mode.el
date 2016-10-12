;;; init-markdown-mode.el --- A setting of the markdown-mode.
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))

(defun elim:markdown-mode-hook-fun()
  (define-key gfm-mode-map "`" 'self-insert-command))

(add-hook 'markdown-mode-hook #'elim:markdown-mode-hook-fun)

(provide 'init-markdown-mode)

;;; init-markdown-mode.el ends here
