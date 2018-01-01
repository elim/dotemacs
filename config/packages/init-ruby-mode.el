;;; init-ruby-mode.el --- A setting of the ruby-mode.
;;; Commentary:
;;; Code:

(use-package ruby-mode
  :bind  (:map ruby-mode-map
               ("C-m" . reindent-then-newline-and-indent))
  :init
  (set-variable 'ruby-deep-indent-paren-style nil)
  (set-variable 'ruby-insert-encoding-magic-comment nil))

(provide 'init-ruby-mode)
;;; init-ruby-mode.el ends here
