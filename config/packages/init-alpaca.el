;;; init-alpaca.el --- A setting of the alpaca.
;;; Commentary:
;;; Code:

(use-package alpaca
  :commands (alpaca-after-find-file)
  :hook (find-file . alpaca-after-find-file))

;;; init-alpaca.el ends here
