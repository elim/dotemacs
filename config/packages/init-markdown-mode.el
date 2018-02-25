;;; init-markdown-mode.el --- A setting of the markdown-mode.
;;; Commentary:
;;; Code:

(use-package markdown-mode
  :bind ((:map gfm-mode-map
               ("`" . self-insert-command)
               ([(meta return)] . elim:toggle-fullscreen)))
  :config
  (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode)))

;;; init-markdown-mode.el ends here
