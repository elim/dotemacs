;;; init-anzu.el --- A setting of the anzu.
;;; Commentary:
;;; Code:

(when (require 'anzu nil t)
  (setq anzu-use-migemo t
    anzu-mode-lighter ""
    anzu-deactivate-region t
    anzu-search-threshold 1000)

  (global-anzu-mode +1)
  (global-set-key [remap query-replace] 'anzu-query-replace)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp))

(provide 'init-anzu)

;;; init-anzu.el ends here
