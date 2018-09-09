;;; init-frame.el --- A setting of the frame.
;;; Commentary:
;;; Code:

(use-package frame
  :if window-system
  :custom
  (line-spacing 4)
  :hook (window-setup . frame-fullscreen))

;;; init-frame.el.el ends here
