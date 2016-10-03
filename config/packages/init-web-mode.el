;;; init-web-mode.el --- A setting of the web-mode.
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

(setq web-mode-block-padding 2)
(setq web-mode-comment-style 2)
(setq web-mode-indent-style 2)
(setq web-mode-script-padding 2)
(setq web-mode-style-padding 2)

(provide 'init-web-mode)

;;; init-web-mode.el ends here
