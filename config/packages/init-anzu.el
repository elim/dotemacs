;;; init-anzu.el --- A setting of the anzu.
;;; Commentary:
;;; Code:

(use-package anzu
  :bind (([remap query-replace]        . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp))
  :init
  (set-variable 'anzu-uxse-migemo t)
  (set-variable 'anzu-mode-lighter "")
  (set-variable 'anzu-deactivate-region t)
  (set-variable 'anzu-search-threshold 1000)
  :config
  (global-anzu-mode +1))

(provide 'init-anzu)

;;; init-anzu.el ends here
