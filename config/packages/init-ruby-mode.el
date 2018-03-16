;;; init-ruby-mode.el --- A setting of the ruby-mode.
;;; Commentary:
;;; Code:

(use-package ruby-mode
  :bind  (:map ruby-mode-map
               ("C-m" . reindent-then-newline-and-indent))
  :custom
  (ruby-deep-indent-paren-style nil)
  (ruby-flymake-use-rubocop-if-available nil)
  (ruby-insert-encoding-magic-comment nil)
  (ruby-use-smie nil))

;;; init-ruby-mode.el ends here
