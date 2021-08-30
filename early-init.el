;;; early-init.el --- undoc
;;; Commentary:

;;; Code:

(set-variable 'ns-use-native-fullscreen nil)
(set-variable 'x-super-keysym 'meta)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)

(push '(fullscreen . maximized) default-frame-alist)

(provide 'early-init)
;;; early-init.el ends here
