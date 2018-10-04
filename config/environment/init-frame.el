;;; init-frame.el --- A setting of the frame.
;;; Commentary:
;;; Code:

(use-package frame
  :if window-system
  :config
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  :custom
  (line-spacing 4)
  :hook (window-setup . frame-fullscreen))

;;; init-frame.el.el ends here
