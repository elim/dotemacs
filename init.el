;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; functions
(defun my-add-path (target-list path-list)
  (condition-case err
	(eval target-list)
    (error (set target-list (list))))
  (dolist (p (reverse path-list))
    (when (file-accessible-directory-p p)
      (add-to-list target-list
		   (expand-file-name p)))))

(defun domestic-network-member-p ()
  (let
      ((domestic-domain
	"fascinating.local$")
       (airport
	"/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport")
       (fon-bssid
	"00:18:84:1a:df:d6"))
    (or
     (string-match domestic-domain system-name)
     (and
      (string= system-type "darwin")
      (string-match fon-bssid
		    (shell-command-to-string
		     (concat airport " --getinfo | grep BSSID")))))))

;; variables
(setq my-lisp-path (expand-file-name "~/.emacs.d/"))

(my-add-path 'load-path
	     (list my-lisp-path "/usr/local/share/emacs/site-lisp/"))

(my-add-path 'exec-path
	     (list "~/bin"
		   "/usr/local/bin"
		   "/usr/local/sbin"
		   "/opt/local/bin"
		   "/opt/local/sbin"
		   "/sw/bin"
		   "/sw/sbin/"
		   "/Developer/Tools"
		   "c:/cygwin/usr/bin"
		   "c:/cygwin/usr/sbin"
		   "c:/cygwin/usr/local/bin"
		   "c:/cygwin/usr/local/sbin"
		   "/usr/games"
		   "/usr/X11R6/bin"
		   "C:/Program Files/Mozilla Firefox"))

(my-add-path 'Info-additional-directory-list
	     (list "/opt/local/share/info"
		   "/sw/info"
		   "/sw/share/info"
		   "c:/cygwin/usr/share/info"
		   "c:/cygwin/usr/local/share/info"))

(setq custom-file
      (expand-file-name (concat my-lisp-path "/customize.el")))

;; load libraries
(load "eval-safe.el")
(load "autoload-if-found.el")
(load "auto-save-buffers.el")
(load "completions-highlight.el")
(load "make-file-executable.el")

;; load initial settings
(load "init-auto-save-buffers.el")
(load "init-browse-url.el")
(load "init-browse-kill-ring.el")
(load "init-css-mode.el")
(load "init-ddskk.el")
(load "init-develock.el")
(load "init-dired-mode.el")
(load "init-elscreen.el")
(load "init-fonts.el")
(load "init-frame.el")
(load "init-howm.el")
(load "init-html-helper-mode.el")
(load "init-iswitchb.el")
(load "init-language.el")
(load "init-lookup.el")
(load "init-navi2ch.el")
(load "init-misc.el")
(load "init-mmm-mode.el")
(load "init-mpg123.el")
(load "init-mwheel.el")
(load "init-outline-mode.el")
(load "init-psvn.el")
(load "init-pukiwiki-mode.el")
(load "init-riece.el")
(load "init-ruby.el")
(load "init-rails.el")
(load "init-semi.el")
(load "init-session.el")
(load "init-server.el")
(load "init-shimbun.el")
(load "init-tdiary-mode.el")
(load "init-tiarra-conf.el")
(load "init-tramp.el")
(load "init-w3m.el")
(load "init-wget.el")
(load "init-wl.el")

(when (functionp 'howm-menu)
  (howm-menu))
