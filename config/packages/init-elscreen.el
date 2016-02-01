;;; init-elscreen.el --- A setting of the elscreen.
;;; Commentary:
;;; Code:

(require 'elscreen)

(setq elscreen-tab-display-control nil
      elscreen-tab-display-kill-screen nil
      elscreen-display-tab t)

(elscreen-set-prefix-key [(control z)])
(set-face-attribute 'elscreen-tab-background-face nil
                    :foreground "#112"
                    :background "#ccc"
                    :underline nil
                    :height 1.2
                    :box nil)

(set-face-attribute 'elscreen-tab-control-face nil
                    :foreground "#ccc"
                    :background "#112"
                    :underline nil
                    :height 1.2
                    :box nil)

(set-face-attribute 'elscreen-tab-current-screen-face nil
                    :foreground "#ccc"
                    :background "#336"
                    :underline nil
                    :height 1.2
                    :box nil)

(set-face-attribute 'elscreen-tab-other-screen-face nil
                    :foreground "#ccc"
                    :background "#112"
                    :underline nil
                    :height 1.2
                    :box nil)

(elscreen-start)

(provide 'init-elscreen)
;;; init-elscreen.el ends here
