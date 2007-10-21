;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;;; provisional measures for cygwin $PWD environment variable.
(when
    (not (file-directory-p default-directory))
  (setq default-directory (getenv "HOME")))

;;; checking and/or loading Common Lisp extensions.
(when (require 'apropos nil t)
  (when (not (apropos-macrop 'dolist))
    (require 'cl nil t)))

;;; path and filenames.
(setq base-directory "~/.emacs.d")
(setq preferences-directory "~/.emacs.d")
(setq libraries-directory
  (expand-file-name "library" base-directory))

(setq custom-file
      (expand-file-name "customize.el" base-directory))

(defun coordinate-path (target-list path-list)
  (condition-case err
      (eval target-list)
    (error (set target-list (list))))
  (dolist (p (reverse path-list))
    (when (file-accessible-directory-p p)
      (add-to-list target-list
		   (expand-file-name p)))))

(coordinate-path 'load-path
		 (list base-directory
		       preferences-directory
		       libraries-directory
		       "/usr/local/share/emacs/site-lisp/"))

(coordinate-path 'exec-path
		 (list "~/bin"
		       "/bin/"
		       "/sbin/"
		       "/usr/bin/"
		       "/usr/sbin/"
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
		       "c:/program files/mozilla firefox"))

(coordinate-path 'Info-additional-directory-list
		 (list "/Applications/Emacs.app/Contents/Resources/info/"
		       "/opt/local/share/info"
		       "/sw/info"
		       "/sw/share/info"
		       "c:/cygwin/usr/share/info"
		       "c:/cygwin/usr/local/share/info"))

;;; networking.
(defun get-ip-address ()
  (interactive)
  (let
      ((traceroute
	(or
	 (locate-library "traceroute" nil exec-path)
	 (locate-library "tracert.exe" nil exec-path)))
       (host-name
	(if (isPlainHostName system-name)
	  system-name
	  (progn
	    (string-match "\\(.+?\\)\\." system-name)
	    (match-string-no-properties 1 system-name)))))

    (if traceroute
	(with-temp-buffer
	  (call-process traceroute nil t nil host-name)
	  (goto-char (point-min))
	  (if (re-search-forward "[^0-9]*\\([0-9]+\\(\.[0-9]+\\)+\\)" nil t)
	      (match-string 1)))
      "unknown")))

(defun domestic-network-member-p ()
  (let
      ((domestic-address "^192.168.119.")
       (domestic-domain-name "fascinating.local$"))
    (and
     (string-match domestic-address (get-ip-address))
     (string-match domestic-domain-name system-name))))

(defun load-directory-files (directory file-regex)
  (when (file-accessible-directory-p directory)
    (dolist (f (directory-files directory t file-regex))
      (load f nil t))))

;; load essential libraries.
(load-directory-files libraries-directory "^.+el$")

;; load preferences.
(load-directory-files preferences-directory "^init-.+el$")

(when (functionp 'howm-menu) (howm-menu))
