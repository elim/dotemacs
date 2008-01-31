;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (let
	  ((exec "sysctl")
	   (arg "keyremap4macbook.version"))

	(and (locate-executable exec)
	     (equal "keyremap4macbook"
		    (with-temp-buffer
		      (call-process exec nil t nil arg)
		      (goto-char (point-min))
		      (if (re-search-forward "\\(\\w+\\)" nil t)
			  (match-string 0))))))

(locate-executable "sysctl")
  (and
   (global-set-key [(control x) (right)] #'find-file)

   (eval-after-load "elscreen"
     #'(and
	(define-key elscreen-map [(right)]  #'elscreen-find-file)
	(define-key elscreen-map [(up)]     #'elscreen-previous)
	(define-key elscreen-map [(down)]   #'elscreen-next)))

   (eval-after-load "riece"
     #'(and
	(define-key riece-dialogue-mode-map [(up)] #'riece-command-part)
	(define-key riece-dialogue-mode-map [(down)] #'riece-command-names)))))