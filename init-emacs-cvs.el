;; -*- emacs-lisp -*-
;; $Id$
;; for emacs-dev

(when (not (boundp 'debian-emacs-flavor))
  (when (load "/usr/share/emacs/site-lisp/debian-startup.el" t)
    (setq flavor 'emacs21)
    (add-to-list 'load-path
		 "/usr/local/share/emacs/site-lisp")
    (debian-startup 'emacs21)
    (debian-startup 'emacs21)))
