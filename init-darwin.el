;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; carbon emacs
(setq mac-pass-control-to-system nil
      mac-pass-command-to-system nil
      mac-option-modifier 'meta)

(when (let
	  ((exec "sysctl")
	   (arg "keyremap4macbook.option.emacsmode_controlPNBF"))

	(and (locate-executable exec)
	     (string-equal "1"
		    (with-temp-buffer
		      (call-process exec nil t nil arg)
		      (goto-char (point-min))
		      (if (re-search-forward "\\(.\\)$" nil t)
			  (match-string 0))))))
  (and
   (global-set-key [(control x) (right)] #'find-file)

   (defadvice define-key (around keyreremap (keymap key def)
				 activate)
     (setq key
	   (cond
	    ((vectorp key) (apply 'vector
				  (mapcar
				   #'(lambda (k)
				       (cond
					((equal "\C-p" k) '(up))
					((equal "\C-n" k) '(down))
					((equal "\C-b" k) '(left))
					((equal "\C-f" k) '(right))
					(t k)))
				   key)))
	    ((stringp key) (cond
			    ((equal "\C-p" key) [(up)])
			    ((equal "\C-n" key) [(down)])
			    ((equal "\C-b" key) [(left)])
			    ((equal "\C-f" key) [(right)])
			    (t key)))
	    (t key)))

     ad-do-it)))