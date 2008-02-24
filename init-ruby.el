;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'ruby-mode nil t)
  (when (require 'inf-ruby nil t)
    (let
	((path (locate-library "irb" nil exec-path)))
      (unless (file-executable-p path)
	(setq ruby-program-name
	      (mapconcat #'identity
			 (list "ruby" path "--inf-ruby-mode") " ")))))

  (require 'ruby-electric nil t)

  (setq ruby-indent-level 2
	ruby-indent-tabs-mode nil

	auto-mode-alist
	(cons '("\\.rb$" . ruby-mode) auto-mode-alist)

	interpreter-mode-alist
	(cons '("ruby" . ruby-mode) interpreter-mode-alist))

  (add-hook 'ruby-mode-hook
	    '(lambda ()
	       (inf-ruby-keys))))