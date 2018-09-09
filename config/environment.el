;;; environment.el -- A setting of the environments.
;;; Commentary:
;;; Code:

(setq select-enable-clipboard t)

(defalias 'yes-or-no-p 'y-or-n-p)

(load "environment/fonts")
(load "environment/init-cocoa")
(load "environment/init-frame")

;;; environment.el ends here
