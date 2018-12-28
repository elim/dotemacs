;;; init-elscreen.el --- A setting of the elscreen.
;;; Commentary:
;;; Code:

(use-package elscreen
  :config
  (elscreen-set-prefix-key [(control z)])
  (elscreen-start)

  :custom
  (elscreen-tab-display-control nil)
  (elscreen-tab-display-kill-screen nil)
  (elscreen-display-tab t)

  :custom-face
  (elscreen-tab-background-face     ((nil (:foreground "#112" :background "#ccc" :underline nil :height 1.2 :box nil))))
  (elscreen-tab-control-face        ((nil (:foreground "#ccc" :background "#112" :underline nil :height 1.2 :box nil))))
  (elscreen-tab-current-screen-face ((nil (:foreground "#ccc" :background "#336" :underline nil :height 1.2 :box nil))))
  (elscreen-tab-other-screen-face   ((nil (:foreground "#ccc" :background "#112" :underline nil :height 1.2 :box nil)))))


;;; init-elscreen.el ends here
