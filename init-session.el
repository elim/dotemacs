;; -*- emacs-lisp -*-
;; $Id$

(when (require 'session nil t)
  (setq history-length t)
  (setq session-initialize '(de-saveplace session keys menus))
  (setq session-globals-include '((kill-ring 255)
				  (session-file-alist 255 t)
				  (file-name-history 255)))
  (setq session-globals-max-size 1024)
  (setq session-globals-max-string 1024)
  (setq session-save-file (expand-file-name "session-save.el" base-directory))
  (add-hook 'after-init-hook 'session-initialize))
