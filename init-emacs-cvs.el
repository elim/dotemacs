; -*- emacs-lisp -*-
; $Id$
;; for emacs-dev
(if (not (boundp 'debian-emacs-flavor))
    (if (load "/usr/share/emacs/site-lisp/debian-startup.el" t)
	(progn
	  (setq flavor 'emacs21)
	  (add-to-list 'load-path
		       "/usr/local/share/emacs/21.3/site-lisp")
	  (debian-startup 'emacs21)
	  (debian-startup 'emacs21))))
