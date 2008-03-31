;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(and (require 'elscreen nil t)
     (elscreen-set-prefix-key [(control l)])
     (setq elscreen-display-tab t)

     (mapc '(lambda (arg)
	       (and (locate-library arg)
		    (require (intern (format "elscreen-%s" arg)) nil t)))
	   (list
	    "dired" "howm"
	    "server" "w3m" "wl")))

(add-hook 'wl-draft-mode-hook
	  '(lambda ()
	     (mapc '(lambda (pair)
		      (apply #'define-key (current-local-map) pair))
		   (list
		    '([(control l)] nil)
		    '([(control c) l] 'wl-draft-highlight-and-recenter)
		    '([(control c) (control l)] 'wl-draft-highlight-and-recenter)))))
