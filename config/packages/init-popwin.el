;;; init-popwin.el --- A setting of the popwin.
;;; Commentary:
;;; Code:

(require 'popwin)

(popwin-mode 1)
(setq popwin:popup-window-position 'bottom
      popwin:popup-window-height 20)

(push '("*Google Translate*") popwin:special-display-config)
(push '("*ginger*")           popwin:special-display-config)
(push '("*rephrase*")         popwin:special-display-config)

(provide 'init-popwin)
;;; init-popwin.el ends here
