;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(when window-system
  (setq-default line-spacing
		(if (featurep 'mac-carbon) nil 2))
  (setq initial-frame-alist
	(append
	 '((foreground-color . "gray")
	   (background-color . "black")
	   (cursor-color  . "blue")
	   (alpha  . (90 100)))
	 default-frame-alist))

  (when (eq window-system 'mac)
    (set-frame-parameter nil 'alpha '(90 95))

    ;; http://lists.sourceforge.jp/mailman/archives/macemacsjp-english/2006-April/000569.html
    (defun hide-others ()
      (interactive)
      (do-applescript
       "tell application \"System Events\"
          set visible of every process whose (frontmost is false) and (visible is true) to false
        end tell"))

    (defun hide-emacs ()
      (interactive)
      (do-applescript
       "tell application \"System Events\"
          set theFrontProcess to process 1 whose (frontmost is true) and (visible is true)
          set visible of theFrontProcess to false
        end tell")))

  ;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=save%20framesize
  (defvar frame-size-configuration-file
    (expand-file-name "framesize.el" base-directory))

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
      (save-buffer 0)))

  (defun window-size-load ()
    (let* ((file frame-size-configuration-file))
      (if (file-exists-p file)
	  (load file))))

  ;; Call the function above at C-x C-c.
  (add-hook 'kill-emacs-hook
	    (lambda ()
	      (window-size-save)))

  (add-hook 'window-setup-hook
	    (lambda ()
	      (if (and (eq window-system 'mac)
		       (functionp #'mac-toggle-max-window))
		  (condition-case ERR
		      (catch 'retry-max-window
			(progn (mac-toggle-max-window)
			       (display-battery-mode t))
			(error (throw 'retry-max-window t))))
		(window-size-load)))))