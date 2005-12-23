;-*- emacs-lisp -*-
; $Id$

(when (autoload-if-found 'tdiary-mode "tdiary-mode" nil t)
  (autoload-if-found 'tdiary-new "tdiary-mode" nil t)
  (autoload-if-found 'tdiary-update "tdiary-mode" nil t)
  (autoload-if-found 'tdiary-replace "tdiary-mode" nil t)

  (setq tdiary-passwd-file (expand-file-name "~/.tdiary-password"))
  (setq tdiary-diary-list
	'(("l"
	   "http://elim.teroknor.org/life_log/")))

  (setq psgml-html-build-new-buffer nil)
  (setq tdiary-browser-function 'browse-url))