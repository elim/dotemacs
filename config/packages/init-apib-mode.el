;;; init-apib-mode.el --- A setting of the apib-mode.
;;; Commentary:
;;; Code:

(autoload 'apib-mode "apib-mode"
        "Major mode for editing API Blueprint files" t)
(add-to-list 'auto-mode-alist '("\\.apib\\'" . apib-mode))

;;; init-apib-mode.el ends here
