;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'ruby-mode nil t)
  (require 'ruby-electric nil t)
  (let
      ((ruby (locate-executable "ruby"))
       (irb (locate-library "irb" nil exec-path))
       (arg "--inf-ruby-mode -Ku"))
    (when (and irb (not (file-executable-p irb)))
      (and
       (setq ruby-program-name
	     (mapconcat #'identity
			(list ruby irb arg) " "))
       (when (require 'inf-ruby nil t)
	 (define-key inferior-ruby-mode-map
	   "\C-\M-p"  #'comint-previous-input)))))


  (setq ruby-indent-level 2
	ruby-indent-tabs-mode nil

	auto-mode-alist
	(cons '("\\.rb$" . ruby-mode) auto-mode-alist)

	interpreter-mode-alist
	(cons '("ruby" . ruby-mode) interpreter-mode-alist))

  (add-hook 'ruby-mode-hook
	    '(lambda ()
	       (inf-ruby-keys))))