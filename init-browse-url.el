;-*- emcs-lisp -*-
; $Id$

(global-set-key [(hyper m)] 'browse-url-at-point)
(global-set-key "\C-xm" 'browse-url-at-point)

(setq browse-url-browser-display nil)
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "/home/takeru/bin/firefox")
(setq browse-url-new-window-flag nil)
