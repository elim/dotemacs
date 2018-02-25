;;; init-buffer-move.el --- A setting of the buffer-move.
;;; Commentary:
;;; Code:

(use-package buffer-move
  :bind (("M-g h" . buf-move-left)
         ("M-g j" . buf-move-down)
         ("M-g k" . buf-move-up)
         ("M-g l" . buf-move-right)))

;;; init-buffer-move.el ends here
