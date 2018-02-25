;;; init-open-junk-file.el --- A setting of the open-junk-file.
;;; Commentary:
;;; Code:

(use-package open-junk-file
  :bind ("C-x C-z" . open-junk-file)
  :custom
  (open-junk-file-format "~/.junk/%Y/%m/%d-%H%M%S.")
  (open-junk-file-find-file-function #'find-file))

;;; init-open-junk-file.el ends here
