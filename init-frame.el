;; -*- emacs-lisp -*-
;; $Id$

(when window-system
  (setq initial-frame-alist
	(append
	 '((foreground-color . "gray")
	   (background-color . "black")
	   (cursor-color  . "blue"))
	 default-frame-alist))
  
  ;; (when (eq window-system 'mac)
  ;;   (when (functionp 'set-active-alpha)
  ;;     (set-active-alpha 0.9))
  ;;   (when (functionp 'set-iactive-alpha)
  ;;     (set-inactive-alpha 0.8))))


  (setq frame-size-configuration-file (expand-file-name (concat my-lisp-path "/framesize.el")))

  ;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=save%20framesize
  (defun window-size-save ()
    (let* ((rlist (frame-parameters (selected-frame)))
	   (ilist initial-frame-alist)
	   (nCHeight (frame-height))
	   (nCWidth (frame-width))
	   (tMargin (if (integerp (cdr (assoc 'top rlist)))
			(cdr (assoc 'top rlist)) 0))
	   (lMargin (if (integerp (cdr (assoc 'left rlist)))
			(cdr (assoc 'left rlist)) 0))
	   buf
	   (file frame-size-configuration-file))
      (if (get-file-buffer (expand-file-name file))
	  (setq buf (get-file-buffer (expand-file-name file)))
	(setq buf (find-file-noselect file)))
      (set-buffer buf)
      (erase-buffer)
      (insert (concat
	       ;; 初期値をいじるよりも modify-frame-parameters
	       ;; で変えるだけの方がいい?
	       "(delete 'width initial-frame-alist) "
	       "(delete 'height initial-frame-alist) "
	       "(delete 'top initial-frame-alist) "
	       "(delete 'left initial-frame-alist) "
	       "(setq initial-frame-alist "
	       "(append (list "
	       "'(width . " (int-to-string nCWidth) ") "
	       "'(height . " (int-to-string nCHeight) ") "
	       "'(top . " (int-to-string tMargin) ") "
	       "'(left . " (int-to-string lMargin) ")) "
	       "initial-frame-alist)) "
	       "(setq default-frame-alist initial-frame-alist)" ))
      (save-buffer)))
  
  (defun window-size-load ()
    (let* ((file frame-size-configuration-file))
      (if (file-exists-p file)
	  (load file))))
  
  (window-size-load)

  ;; Call the function above at C-x C-c.
  (defadvice save-buffers-kill-emacs
    (before save-frame-size activate)
    (window-size-save)))
