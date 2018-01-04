;;; init-auto-save-buffers-enhanced.el --- A setting of the auto-save-buffers-enhanced.
;;; Commentary:
;;; Code:

(use-package auto-save-buffers-enhanced
  :demand t
  :bind ("C-x as" . auto-save-buffers-enhanced-toggle-activity)
  :custom
  (auto-save-default nil)
  (auto-save-buffers-enhanced-cooperate-elscreen-p t)
  (auto-save-buffers-enhanced-quiet-save-p t)
  (auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t)
  :config
  (auto-save-buffers-enhanced t))

(provide 'init-auto-save-buffers-enhanced)

;;; init-auto-save-buffers-enhanced.el ends here
