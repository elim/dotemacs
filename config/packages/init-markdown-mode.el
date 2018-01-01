;;; init-markdown-mode.el --- A setting of the markdown-mode.
;;; Commentary:
;;; Code:

(use-package markdown-mode
  :bind ((:map gfm-mode-map
               ("`" . self-insert-command)))
  :config
  (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode)))

(provide 'init-markdown-mode)

;;; init-markdown-mode.el ends here
