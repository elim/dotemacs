;;; init-migemo.el --- A setting of the migemo.
;;; Commentary:
;;; Code:

(require 'migemo)

(setq migemo-coding-system 'utf-8-unix
      migemo-command "/usr/local/bin/cmigemo"
      migemo-options '("-q" "--emacs")
      migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(migemo-init)

;;; init-migemo.el ends here
