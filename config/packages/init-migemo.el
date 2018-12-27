;;; init-migemo.el --- A setting of the migemo.
;;; Commentary:
;;; Code:

(use-package migemo
  :custom
  (migemo-coding-system 'utf-8-unix)
  (migemo-command "/usr/local/bin/cmigemo")
  (migemo-options '("-q" "--emacs"))
  (migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

  :config
  (migemo-init))

;;; init-migemo.el ends here
