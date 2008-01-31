;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require #'elscreen nil t)
  (elscreen-set-prefix-key "\C-l")
  (setq elscreen-display-tab t)

  (mapcar #'(lambda (arg)
	     (require arg nil t))
	  (list 'elscreen-dired 'elscreen-howm
		'elscreen-w3m 'elscreen-wl
		'elscreen-server)))

(add-hook
 'wl-draft-mode-hook
 '(lambda ()
    (and
      (define-key (current-local-map) "\C-l"
	nil)
      (define-key (current-local-map) "\C-cl"
	'wl-draft-highlight-and-recenter)
      (define-key (current-local-map) "\C-c\C-l"
	'wl-draft-highlight-and-recenter))))