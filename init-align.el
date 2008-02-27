;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
;; based upon
;; http://d.hatena.ne.jp/rubikitch/20080227/1204051280
(when (require 'align nil t)
  (mapc '(lambda (lst)
	   (add-to-list 'align-rules-list lst))
	(list
	 ;; ruby-mode
	 '(ruby-comma-delimiter
	   (regexp . ",\\(\\s-*\\)[^# \t\n]")
	   (repeat . t)
	   (modes  . '(ruby-mode)))

	 '(ruby-hash-literal
	   (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
	   (repeat . t)
	   (modes  . '(ruby-mode)))

	 '(ruby-assignment-literal
	   (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
	   (repeat . t)
	   (modes  . '(ruby-mode)))

	 '(ruby-xmpfilter-mark ;;TODO add to rcodetools.el
	   (regexp . "\\(\\s-*\\)# => [^#\t\n]")
	   (repeat . nil)
	   (modes  . '(ruby-mode))))))