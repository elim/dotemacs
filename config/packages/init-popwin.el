;;; init-popwin.el --- A setting of the popwin.
;;; Commentary:
;;; Code:

(use-package popwin
  :config
  (push '("*Google Translate*") popwin:special-display-config)
  (push '("*ginger*")           popwin:special-display-config)
  (push '("*rephrase*")         popwin:special-display-config)
  (popwin-mode 1)

  :custom
  (popwin:popup-window-position 'bottom)
  (popwin:popup-window-height 20))

;;; init-popwin.el ends here
