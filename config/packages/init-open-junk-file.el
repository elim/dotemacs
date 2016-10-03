;;; init-open-junk-file.el --- A setting of the open-junk-file.
;;; Commentary:
;;; Code:

(setq open-junk-file-format "~/.junk/%Y/%m/%d-%H%M%S.")
(setq open-junk-file-find-file-function #'find-file)

(define-key global-map (kbd "C-x C-z") 'open-junk-file)

(provide 'init-open-junk-file)

;;; init-open-junk-file.el ends here
