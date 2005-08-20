;-*- emacs-lisp -*-
; $Id$

(if window-system
    (progn
      (setq default-frame-alist
	    (append
	     '((foreground-color . "gray")
	       (background-color . "black")
	       (cursor-color  . "blue")
	       (width . 100)
	       (height . 40)
	       (top . 10)
	       (left . 10))
	     default-frame-alist))))