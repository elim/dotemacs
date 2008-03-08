;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'ruby-mode nil t)
  (require 'ruby-electric nil t)
  (when (require 'inf-ruby nil t)
    (let
	((ruby (locate-executable "ruby"))
	 (irb (locate-library "irb" nil exec-path))
	 (arg "--inf-ruby-mode -Ku"))
      (when (and irb (not (file-executable-p irb)))
	(and
	 (setq ruby-program-name
	       (mapconcat #'identity
			  (list ruby irb arg) " "))))
      (mapc '(lambda (lst)
	       (apply #'define-key inferior-ruby-mode-map lst))
	    (list
	     '("\C-p"  comint-previous-input)
	     '("\C-n"  comint-next-input)))
      (add-hook 'ruby-mode-hook
	    '(lambda ()
	       (ruby-electric-mode)))))

  (setq ruby-indent-level 2
	ruby-indent-tabs-mode nil

	auto-mode-alist
	(cons '("\\.rb$" . ruby-mode) auto-mode-alist)

	interpreter-mode-alist
	(cons '("ruby" . ruby-mode) interpreter-mode-alist))

  (add-hook 'ruby-mode-hook
	    '(lambda ()
	       (inf-ruby-keys))))
