;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'elscreen nil t)
  (elscreen-set-prefix-key "\C-l")
  (setq elscreen-display-tab t)

  (mapc #'(lambda (arg)
	    (require arg nil t))
	(list 'elscreen-dired 'elscreen-howm
	      'elscreen-w3m 'elscreen-wl
	      'elscreen-server))

  (add-hook
   'wl-draft-mode-hook
   '(lambda ()
      (mapc
       (lambda (key)
	 (define-key (current-local-map) key
	   (if (string-equal elscreen-prefix-key key)
	       nil #'wl-draft-highlight-and-recenter)))
       (list "\C-l" "\C-cl" "\C-c\C-l")))))
