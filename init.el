;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;;; checking and loading Common Lisp extensions.
(when (not (apropos-macrop 'dolist))
  (require 'cl nil t))

;;; path and filenames.
(setq my-lisp-path (expand-file-name "~/.emacs.d/"))
(setq custom-file
      (expand-file-name (concat my-lisp-path "/customize.el")))

(defun my-add-path (target-list path-list)
  (condition-case err
       (eval target-list)
    (error (set target-list (list))))
  (dolist (p (reverse path-list))
    (when (file-accessible-directory-p p)
      (add-to-list target-list
		   (expand-file-name p)))))

(my-add-path 'load-path
	     (list my-lisp-path "/usr/local/share/emacs/site-lisp/"))

(my-add-path 'exec-path
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

(my-add-path 'Info-additional-directory-list
	     (list "/opt/local/share/info"
		   "/sw/info"
		   "/sw/share/info"
		   "c:/cygwin/usr/share/info"
		   "c:/cygwin/usr/local/share/info"))

;;; networking.
(defun get-ip-address ()
  (interactive)
  (let*
      ((traceroute
	(cond
	 ((locate-library "traceroute" nil exec-path) "traceroute")
	 ((locate-library "tracert" nil exec-path) "tracert")
	 (t nil)))
       
       (return-value
	(if traceroute
	    (shell-command-to-string
	     (concat traceroute " " system-name))
	  "")))
    
    (string-match "[^0-9]*\\([0-9]+\\(\.[0-9]+\\)+\\)" return-value)
    (match-string 1 return-value)))
  
(defun domestic-network-member-p ()
  (let
      ((domestic-address "^192.168.119.")
       (domestic-domain-name "fascinating.local$"))
    (and
     (string-match domestic-address (get-ip-address))
     (string-match domestic-domain-name system-name))))

;; load essential libraries.
(load "eval-safe.el")
(load "autoload-if-found.el")
(load "auto-save-buffers.el")
(load "completions-highlight.el")
(load "make-file-executable.el")

;; load initialization files.
(when (file-accessible-directory-p my-lisp-path)
  (dolist (f (directory-files my-lisp-path))
    (when (string-match "^init-.*el$" f)
      (load (expand-file-name (concat my-lisp-path "/" f))))))

(when (functionp 'howm-menu) (howm-menu))

;; __END__

;; fragments.
(let*
    ((domestic-router (shell-command-to-string "arp -a"))
     (mac-addr
      (progn
	(string-match "\\([0-9A-Fa-f]+?[:-].*?\\)[\s]" domestic-router)
	(match-string 1 domestic-router)))
     (normalized-mac-addr "")
     (temporary-char ""))
  
  (dotimes (i (length mac-addr) normalized-mac-addr)
    (setq temporary-char (format "%c" (elt mac-addr i)))
    (unless (string-match ":" temporary-char)
      (setq normalized-mac-addr (concat normalized-mac-addr temporary-char)))))