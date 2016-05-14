;;; init-anzu.el --- A setting of the anzu.
;;; Commentary:
;;; Code:

(with-eval-after-load-feature 'anzu
  (global-anzu-mode +1)
  (global-set-key [remap query-replace] 'anzu-query-replace)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp))

(provide 'init-anzu)

;;; init-anzu.el ends here