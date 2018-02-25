;;; init-web-mode.el --- A setting of the web-mode.
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ctp\\'"  . web-mode))

(setq web-mode-block-padding 2)
(setq web-mode-comment-style 2)
(setq web-mode-enable-engine-detection t)
(setq web-mode-indent-style 2)
(setq web-mode-script-padding 2)
(setq web-mode-style-padding 2)

;;; init-web-mode.el ends here
