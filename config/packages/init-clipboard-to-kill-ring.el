;;; init-clipboard-to-kill-ring.el --- A setting of the clipboard-to-kill-ring.
;;; Commentary:
;;; Original: http://hitode909.hatenablog.com/entry/20110924/1316853933
;;; Modified: https://gist.github.com/elim/666807b53f2b2cf503c1
;;; Code:

(use-package clipboard-to-kill-ring
  :bind (("C-x ck" . elim:toggle-clipboard-to-kill-ring))

  :config
  (defun elim:toggle-clipboard-to-kill-ring ()
    "Toggle `clipboard-to-kill-ring' activity."
    (interactive)
    (let* ((enabled-p clipboard-to-kill-ring:timer)
           (after-value (not enabled-p)))
      (clipboard-to-kill-ring after-value)
      (message "clipboard-to-kill-ring %s" (if after-value "on" "off"))))

  (clipboard-to-kill-ring +1)

  :demand t)

;;; init-clipboard-to-kill-ring.el ends here
