;; -*- emacs-lisp -*-
;; $Id$

(when (and (functionp 'server-start)
	   (not (featurep 'meadow)))
  (setq server-window 'pop-to-buffer)

  ;; svn.*tmp を開いたら Changelog mode にする.
  (when (functionp 'add-change-log-entry)
    (add-hook 'server-visit-hook
	      (lambda ()
		(when (string-match "svn.*tmp" buffer-file-name)
		  (add-change-log-entry nil (buffer-file-name))))))

  (server-start))


