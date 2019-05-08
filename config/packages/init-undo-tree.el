;;; init-undo-tree.el --- A setting of the undo-tree.
;;; Commentary:
;;; Code:

(use-package undo-tree
  :custom
  (undo-tree-enable-undo-in-region nil)

  :config
  (global-undo-tree-mode t))

;;; init-undo-tree.el ends here
