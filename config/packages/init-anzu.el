;;; init-anzu.el --- A setting of the anzu.
;;; Commentary:
;;; Code:

(use-package anzu
  :bind (([remap query-replace]        . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp))
  :custom
  (anzu-use-migemo t)
  (anzu-mode-lighter "")
  (anzu-deactivate-region t)
  (anzu-search-threshold 1000)

  :config
  (global-anzu-mode +1))

(provide 'init-anzu)

;;; init-anzu.el ends here
