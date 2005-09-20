;-*- emacs-lisp -*-
; $Id$

(global-set-key [(hyper m)] 'browse-url-at-point)
(global-set-key "\C-xm" 'browse-url-at-point)

(setq browse-url-browser-display nil)
(setq browse-url-browser-function 'browse-url-generic)

(cond
 ((featurep 'meadow)
  (setq browse-url-generic-program
	"c:/Program Files/Mozilla Firefox/firefox.exe"))
 ((featurep 'carbon-emacs-package)
  (setq browse-url-generic-program
	"open"))
 (t
  (setq browse-url-generic-program "~/bin/firefox")))
(setq browse-url-new-window-flag nil)
