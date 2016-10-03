;;; init-auto-save-buffers-enhanced.el --- A setting of the auto-save-buffers-enhanced.
;;; Commentary:
;;; Code:

(require 'auto-save-buffers-enhanced)

(setq auto-save-default nil
      auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t
      auto-save-buffers-enhanced-cooperate-elscreen-p t
      auto-save-buffers-enhanced-quiet-save-p t)
(define-key global-map "\C-xas" 'auto-save-buffers-enhanced-toggle-activity)
(auto-save-buffers-enhanced t)

(provide 'init-auto-save-buffers-enhanced)

;;; init-auto-save-buffers-enhanced.el ends here
