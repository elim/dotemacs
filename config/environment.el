;;; environment.el -- A setting of the environments.
;;; Commentary:
;;; Code:

(defalias 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'yes-or-no-p)
(setq select-enable-clipboard t)

(load "environment/frame")
(load "environment/fonts")

;;; environment.el ends here

