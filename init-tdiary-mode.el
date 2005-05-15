;-*- emcs-lisp -*-
; $Id$

(autoload 'tdiary-mode "tdiary-mode" "starting tidary-mode..." t)
(autoload 'tdiary-new "tdiary-mode" "starting tidary-mode..." t)
(autoload 'tdiary-replace "tdiary-mode" "starting tidary-mode..." t)
(autoload 'tdiary-update "tdiary-mode" "starting tidary-mode..." t)

(setq tdiary-passwd-file (expand-file-name "~/.tdiary-password"))
(setq tdiary-diary-list
      '(("p" "http://elim.teroknor.org/%7Etakeru/private_log/")
	("l" "http://elim.teroknor.org/%7Etakeru/life_log/"
	 "index.rb" "update.rb")))

(setq psgml-html-build-new-buffer nil)
