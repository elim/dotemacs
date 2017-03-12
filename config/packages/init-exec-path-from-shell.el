;;; init-exec-path-from-shell.el --- A setting of the exec-path-from-shell.
;;; Commentary:
;;; Code:

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(provide 'init-exec-path-from-shell)

;;; init-exec-path-from-shell.el ends here
