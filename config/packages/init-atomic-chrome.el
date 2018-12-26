;;; init-atomic-chrome.el --- A setting of the atomic-chrome.
;;; Commentary:
;;; Code:

(use-package atomic-chrome
  :custom
  (atomic-chrome-default-major-mode 'markdown-mode)
  (atomic-chrome-url-major-mode-alist
   '(("github\\.com" . gfm-mode)
     ("esa\\.io"     . gfm-mode)
     ("redmine"      . textile-mode)))

  :config
  (atomic-chrome-start-server))

;;; init-atomic-chrome.el ends here
