;;; init-buffer-move.el --- A setting of the buffer-move.
;;; Commentary:
;;; Code:

(global-set-key (kbd "M-g h") 'buf-move-left)
(global-set-key (kbd "M-g j") 'buf-move-down)
(global-set-key (kbd "M-g k") 'buf-move-up)
(global-set-key (kbd "M-g l") 'buf-move-right)

(provide 'init-buffer-move)

;;; init-buffer-move.el ends here
