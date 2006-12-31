;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when 
    (and (require 'find-recursive nil t)
	 (require 'snippet nil t)
	 (locate-library "rails"))
  (defun try-complete-abbrev (old)
    (if (expand-abbrev) t nil))
  
  (setq hippie-expand-try-functions-list
	'(try-complete-abbrev
	  try-complete-file-name
	  try-expand-dabbrev))
  
  (require 'rails))
