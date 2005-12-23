; -*- emacs-lisp -*-
; $Id$

(when (autoload-if-found
       'pukiwiki-mode "pukiwiki" "Mode for editing pukiwiki ." t)
  (autoload-if-found 'pukiwiki-edit "pukiwiki-mode" nil t)
  (autoload-if-found 'pukiwiki-index "pukiwiki-mode" nil t)
  (autoload-if-found 'pukiwiki-edit-url "pukiwiki-mode" nil t)

  (setq pukiwiki-site-list
	'(("Elim Wiki"
	   "http://elim.teroknor.org/%7Etakeru/pukiwiki/pukiwiki.php"
	   nil
	   euc-jp-dos)))

  (setq pukiwiki-auto-insert t)
  (setq pukiwiki-browser-function 'w3m-browse-url)
  (setq pukiwiki-diff-using-ediff t))







