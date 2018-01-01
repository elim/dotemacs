;;; init-open-junk-file.el --- A setting of the open-junk-file.
;;; Commentary:
;;; Code:

(use-package open-junk-file
  :bind ("C-x C-z" . open-junk-file)
  :config
  (set-variable 'open-junk-file-format "~/.junk/%Y/%m/%d-%H%M%S.")
  (set-variable 'open-junk-file-find-file-function #'find-file))

(provide 'init-open-junk-file)

;;; init-open-junk-file.el ends here
