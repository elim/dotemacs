;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(when (require 'ruby-mode nil t)
  (setq ruby-indent-level 2
	ruby-indent-tabs-mode nil
	ruby-indnt-paren-style nil)

  (mapc '(lambda (arg)
	   (cons arg auto-mode-alist))
	(list '("\\.rb$" . ruby-mode)
	      '("Rakefile" . ruby-mode)))

  (and (require 'ruby-electric nil t)
       (setq ruby-electric-expand-delimiters-list '(?\{))
       (add-hook 'ruby-mode-hook
		 '(lambda ()
		    (ruby-electric-mode 1))))

  (and (require 'inf-ruby nil t)
       (setq interpreter-mode-alist
	     (cons '("ruby" . ruby-mode) interpreter-mode-alist))
       (let
	   ((ruby (locate-executable "ruby"))
	    (irb (locate-library "irb" nil exec-path))
	    (args (list "--inf-ruby-mode" "-Ku")))

	 (and irb
	      (setq ruby-program-name
		    (mapconcat #'identity
			       `(,ruby ,irb ,@args) " "))

	      (add-hook 'ruby-mode-hook
			'(lambda ()
			   (inf-ruby-keys))))))

  ;; Software Design 2008-02 P152
  ;; devel/which and ffap
  (defun ffap-ruby-mode (name)
    (shell-command-to-string
     (format "
ruby -e '
require %%[rubygems]
require %%[devel/which]
require %%[%s]
print(which_library(%%[%s]))'"
	     name name)))

  (defun find-rubylib (name)
    (interactive "sRuby library name: ")
    (find-file (ffap-ruby-mode name)))

  (and (require 'ffap nil t)
       (add-to-list 'ffap-alist '(ruby-mode . ffap-ruby-mode)))

  ;; Software Design 2008-02 P153
  ;; ri
  (and (locate-executable "fastri-server")
       (locate-executable "fri")
       (setq ri-ruby-script (locate-executable "ri-emacs"))
       (load "ri-ruby" 'noerror)

       (defun force-start-fastri-server ()
	 (let*
	     ((progname "fastri-server")
	      (buffname (format "*%s*" progname)))
	 (with-temp-buffer
	   (call-process-shell-command
	    (format "ps ux |sed -e '/%s/!d' -e '/sed/d'" progname) nil t)
	   (goto-char (point-min))
	   (unless (re-search-forward progname nil t)
	       (with-current-buffer (get-buffer-create buffname)
		 (erase-buffer)
		 (start-process progname buffname progname)
		 (while (not
			 (progn
			   (goto-char (point-min))
			   (re-search-forward progname nil t)))
		   (sit-for 0.1)))))))

       (defadvice ri (before ri/force-start-fastri-server activate)
	 (force-start-fastri-server))))