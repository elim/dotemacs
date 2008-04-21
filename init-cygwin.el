;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

;; for Meadow and Cygwin.

;; based upon
;;   meadow-users-jp:3050
;;   http://mechanics.civil.tohoku.ac.jp/soft/node45.html
;;   http://meadow.sourceforge.jp/cgi-bin/hiki.cgi?%B0%EC%C8%CC%C5%AA%A4%CA%BE%F0%CA%F3

(when (featurep 'meadow)
  (setq explicit-shell-file-name (car
				  (remove nil
					  (mapcar #'locate-executable
						  (list "zsh" "bash" "sh"))))
	shell-file-name explicit-shell-file-name
	shell-command-switch "-c"
	;; drive letter completion on shell-mode.
	shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-")

  (add-hook 'shell-mode-hook
	    '(lambda ()
	       (set-buffer-process-coding-system
		'undecided-dos 'sjis-unix)))

  (and (mapcar #'locate-executable
	       (list "getclip" "putclip"))

       (defadvice kill-new (after normalized-clipboard activate)
	 (start-process
	  "normalization of the contents of the clipboard."
	  "*Messages*" shell-file-name shell-command-switch
	  "getclip | setclip"))))