;;; init-clipboard-to-kill-ring.el --- A setting of the clipboard-to-kill-ring.
;;; Commentary:
;;; Original: http://hitode909.hatenablog.com/entry/20110924/1316853933
;;; Modified: https://gist.github.com/elim/666807b53f2b2cf503c1
;;; Code:

(require 'clipboard-to-kill-ring)

(defun elim:toggle-clipboard-to-kill-ring ()
  "Toggle `clipboard-to-kill-ring' activity"
  (interactive)
  (let ((desired-state (not clipboard-to-kill-ring:timer)))
    (clipboard-to-kill-ring desired-state)
    (message "clipboard-to-kill-ring %s" (if desired-state "on" "off"))))

(define-key ctl-x-map (kbd "ck") 'elim:toggle-clipboard-to-kill-ring)

(clipboard-to-kill-ring +1)

(provide 'init-clipboard-to-kill-ring)

;;; init-clipboard-to-kill-ring.el ends here
