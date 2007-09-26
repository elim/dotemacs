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

  (require 'rails)
  (define-key rails-minor-mode-map
    "\C-c\C-p" 'rails-lib:run-primary-switch)
  (define-key rails-minor-mode-map
    "\C-c\C-n" 'rails-lib:run-secondary-switch))

