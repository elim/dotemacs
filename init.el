;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;;; provisional measures for cygwin $PWD environment variable.
(when
    (not (file-directory-p default-directory))
  (setq default-directory (getenv "HOME")))

;;; path and filenames.
(setq base-directory "~/.emacs.d")
(setq preferences-directory "~/.emacs.d")
(setq libraries-directory
  (expand-file-name "library" base-directory))

(setq custom-file
      (expand-file-name "customize.el" base-directory))

(defmacro forced-list-transform (arg)
  (list 'condition-case 'err
	(list 'if (list 'and (list 'boundp arg)(list 'listp arg))
	      arg
	      (list 'list arg))
	(list 'error
	      (list 'cond
		    (list (list 'equal (list 'car 'err) ''void-variable)
			  (list 'list))
		    (list (list 'and
				(list 'equal (list 'car 'err)
				      ''wrong-type-argument)
				(list 'atom arg))
			  (list 'list arg))
		    (list (list 'and
				(list 'equal (list 'car 'err)
				      ''wrong-type-argument)
				(list 'listp arg))
			  arg)
		    (list t (list 'message "%s" 'err))))))

(defmacro marge-lists-without-duplicate (base additional)
  (list 'let
	(list (list 'base (list 'forced-list-transform base))
	      (list 'additional (list 'forced-list-transform additional)))

	(list 'marge-lists-without-duplicate-internal 'base 'additional)))

(defun marge-lists-without-duplicate-internal (base additional)
  (when (car additional)
    (setq base
	 (cons
	  (car additional)
	  (delete (car additional) base))))

  (if (cdr additional)
      (marge-lists-without-duplicate-internal base (cdr additional))
    base))

(setq load-path
      (marge-lists-without-duplicate
       load-path
       (list base-directory
	     preferences-directory
	     libraries-directory
	     "/usr/local/share/emacs/site-lisp/")))
(setq exec-path
      (marge-lists-without-duplicate
       exec-path
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
	     "c:/program files/mozilla firefox")))

(setq Info-additional-directory-list
      (marge-lists-without-duplicate
       Info-additional-directory-list
       (list "/Applications/Emacs.app/Contents/Resources/info/"
	     "/opt/local/share/info"
	     "/sw/info"
	     "/sw/share/info"
	     "c:/cygwin/usr/share/info"
	     "c:/cygwin/usr/local/share/info")))

;;; networking.
(defun get-ip-address ()
  (interactive)
  (let
      ((traceroute
	(or
	 (locate-library "traceroute" nil exec-path)
	 (locate-library "tracert.exe" nil exec-path)))
       (host-name
	(if (string-match "\\." system-name)
	    (progn
	      (string-match "^\\(.+?\\)\\." system-name)
	      (match-string-no-properties 1 system-name))
	  system-name)))

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

(defun load-directory-files (&rest plist)
  "property list details.

:directory => target directory (required).
:regex     => filename regex (defalt:`.+')

he-he-he. Setting this instead of the message you expected?"

  (let*
      ((directory (plist-get plist :directory))
       (regex (or (plist-get plist :regex) ".+"))
       (files (and
	       directory
	       (file-accessible-directory-p directory)
	       (or (plist-get plist :files)
		   (directory-files directory 'full regex)))))

    (mapc '(lambda (file)
	       (when (load file nil t)
		 (message "`%s' loaded." file))) files)))

;; load essential libraries.
(load-directory-files :directory libraries-directory
		      :regex "^.+el$")

;; load preferences.
(load-directory-files :directory preferences-directory
		      :regex "^init-.+el$")

(delete nil (mapc '(lambda (dir)
			  (when (file-accessible-directory-p dir)
			    dir)) (list "~/bin"
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
	     "c:/program files/mozilla firefox")))
