;-*- emacs-lisp -*-
; $Id$

(when (require 'session nil t)
  (setq session-initialize '(de-saveplace session keys menus)
	session-globals-include '((kill-ring 50)
				  (session-file-alist 100 t)
				  (file-name-history 100)))
  (add-hook 'after-init-hook 'session-initialize))