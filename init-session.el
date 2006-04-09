;; -*- emacs-lisp -*-
;; $Id$

(when (require 'session nil t)
  (setq session-initialize '(de-saveplace session keys menus))
  (setq session-globals-include '((kill-ring 5000)
				  (session-file-alist 10000 t)
				  (file-name-history 10000)))
  (setq session-globals-max-size 4096)
  (setq session-globals-max-string 2048)
  (setq session-save-file (expand-file-name (concat my-lisp-path ".session")))
  (add-hook 'after-init-hook 'session-initialize))