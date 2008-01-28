;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id: init-misc.el 234 2007-10-23 13:09:20Z takeru $

;; meadow and cygwin
;; based upon meadow-users-jp:3050 and
;; http://mechanics.civil.tohoku.ac.jp/soft/node45.html and
;; http://meadow.sourceforge.jp/cgi-bin/hiki.cgi?%B0%EC%C8%CC%C5%AA%A4%CA%BE%F0%CA%F3

(when (featurep 'meadow)
  (let
      ((my-shell-file-name
	(car (remove nil
		     (mapcar 'locate-executable '("zsh" "bash" "sh"))))))
    (when my-shell-file-name
      (setq explicit-shell-file-name my-shell-file-name)
      (setq shell-file-name my-shell-file-name)
      (setq shell-command-switch "-c")

      (when (string-match
	     "zsh.+cygwin"
	     (shell-command-to-string
	      (concat my-shell-file-name "--version")))

	(defadvice kill-new (after after-kill-new activate)
	  (start-process
	   "normalization fof the contents of the clipboard."
	   "*Messages*" "zsh"
	   "-c" "cat =(cat /dev/clipboard) > /dev/clipboard"))))

      (add-hook 'shell-mode-hook
		(lambda ()
		  (set-buffer-process-coding-system
		   'undecided-dos 'sjis-unix)))

      ;; shell-modeでの補完 (for drive letter)
      (setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-")))