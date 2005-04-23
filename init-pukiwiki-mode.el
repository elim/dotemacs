; -*- emacs-lisp -*-
; $Id$

(autoload 'pukiwiki-mode "pukiwiki" "Mode for editing pukiwiki ." t)
(autoload 'pukiwiki-edit "pukiwiki-mode" nil t)
(autoload 'pukiwiki-index "pukiwiki-mode" nil t)
(autoload 'pukiwiki-edit-url "pukiwiki-mode" nil t)


(setq pukiwiki-site-list
       '(("Elim Wiki"
	  "http://elim.teroknor.org/%7Etakeru/pukiwiki/pukiwiki.php"
	  nil
	  euc-jp-dos)))

(setq pukiwiki-auto-insert t)
(setq pukiwiki-browser-function 'w3m-browse-url)
(setq pukiwiki-diff-using-ediff t)







