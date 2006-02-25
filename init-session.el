;; -*- emacs-lisp -*-
;; $Id$

(when (require 'session nil t)
  (setq session-initialize '(de-saveplace session keys menus))
  (setq session-globals-include '((kill-ring 500)
				  (session-file-alist 1000 t)
				  (file-name-history 1000)))
  (setq session-globals-max-size 4096)
  (setq session-globals-max-string 2048)
  (setq session-save-file (expand-file-name (concat my-lisp-path ".session")))
  (add-hook 'after-init-hook 'session-initialize))