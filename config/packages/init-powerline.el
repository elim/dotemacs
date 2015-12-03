;;; init-powerline.el --- A setting of the powerline.
;;; Commentary:
;;; Code:

(set-face-attribute 'mode-line nil
                    :foreground "#ccc"
                    :background "#113"
                    :height 1.0
                    :box nil)

(set-face-attribute 'mode-line-inactive nil
                    :foreground "#ccc"
                    :background "#112"
                    :box nil)
(powerline-default-theme)

(provide 'init-powerline)
;;; init-powerline.el ends here
