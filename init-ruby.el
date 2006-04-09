;; -*- emacs-lisp -*-
;; $Id$

(when (autoload-if-found 'ruby-mode "ruby-mode"
			 "Mode for editing ruby source files" t)

  (setq ruby-indent-level 2)
  (setq ruby-indent-tabs-mode nil)

  (setq auto-mode-alist
	(append '(("\\.r\\(b\\|html\\)$" . ruby-mode)) auto-mode-alist))

  (setq interpreter-mode-alist
	(append '(("ruby" . ruby-mode)) interpreter-mode-alist))

  (autoload-if-found 'run-ruby "inf-ruby"
		     "Run an inferior Ruby process")

  (autoload-if-found 'inf-ruby-keys "inf-ruby"
		     "Set local key defs for inf-ruby in ruby-mode")

  (add-hook 'ruby-mode-hook
	    '(lambda ()
	       (inf-ruby-keys))))
