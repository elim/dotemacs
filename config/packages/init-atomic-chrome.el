;;; init-atomic-chrome.el --- A setting of the atomic-chrome.
;;; Commentary:
;;; Code:

(require 'atomic-chrome)

(setq atomic-chrome-default-major-mode 'markdown-mode
  atomic-chrome-url-major-mode-alist
  '(("github\\.com" . gfm-mode)
     ("esa\\.io" . gfm-mode)
     ("redmine" . textile-mode)))

(atomic-chrome-start-server)

(provide 'init-atomic-chrome)
;;; init-atomic-chrome.el ends here
