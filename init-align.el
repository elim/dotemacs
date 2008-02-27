;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
;; based upon
;; http://d.hatena.ne.jp/rubikitch/20080227/1204051280

(when (require 'align nil t)
  ;; ruby-mode
  (mapc '(lambda (lst)
	   (add-to-list 'align-rules-list
			(cons (car lst)
			      (append (cdr lst)
				      (list '(modes . '(ruby-mode)))))))
	(list
	 '(ruby-comma-delimiter
	   (regexp . ",\\(\\s-*\\)[^# \t\n]"))

	 '(ruby-hash-literal
	   (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]"))

	 '(ruby-assignment-literal
	   (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]"))

	 '(ruby-xmpfilter-mark ;;TODO: add to rcodetools.el
	   (regexp . "\\(\\s-*\\)# => [^#\t\n]")
	   (repeat . nil)))))
