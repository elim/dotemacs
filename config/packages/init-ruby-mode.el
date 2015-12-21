;;; init-ruby-mode.el --- A setting of the ruby-mode.
;;; Commentary:
;;; Code:

(setq ruby-deep-indent-paren-style nil
      ruby-insert-encoding-magic-comment nil)

(define-key ruby-mode-map "\C-m" 'reindent-then-newline-and-indent)

(provide 'init-ruby-mode)
;;; init-ruby-mode.el ends here
