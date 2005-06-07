;-*- emacs-lisp -*-
; $Id$

(autoload 'tdiary-mode "tdiary-mode" nil t)
(autoload 'tdiary-new "tdiary-mode" nil t)
(autoload 'tdiary-update "tdiary-mode" nil t)
(autoload 'tdiary-replace "tdiary-mode" nil t)


(setq tdiary-passwd-file (expand-file-name "~/.tdiary-password"))
(setq tdiary-diary-list
      '(("p"
	 "http://elim.teroknor.org/%7Etakeru/private_log/")
	("pl"
	 "http://localhost/%7Etakeru/private_log/")
	("l"
	 "http://elim.teroknor.org/%7Etakeru/life_log/")
	("ll"
	 "http://localhost/%7Etakeru/life_log/")
	("x"
	 "http://elim.s27.xrea.com/LifeLog/" "index.cgi" "update.cgi")))

(setq psgml-html-build-new-buffer nil)

(setq tdiary-browser-function 'browse-url)
