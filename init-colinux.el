;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(when (and (locate-executable "dmesg")
	   (with-temp-buffer
	     (call-process "dmesg" nil t nil)
	     (goto-char (point-min))
	     (if (re-search-forward "^\\(cofuse\\)\.+" nil t)
		 (match-string 1))))

  (defvar clipboard-file-name "~/media/home/tmp/clipboard")

  (defadvice kill-new (after throw-clipboard activate)
    (let
	((str (car kill-ring))
	 (file (expand-file-name clipboard-file-name)))

      (when (file-writable-p file)
	(with-temp-buffer
	  (insert str)
	  (set-buffer-file-coding-system 'sjis-dos)
	  (write-region (point-min) (point-max)
			file nil 'no-message)))))

  (defvar clipboard-synchronize-interval 0.1)
  (defvar clipboard-mtime (let
			      ((current (current-time)))
			    (cons (car current)
				  (cadr current))))

  (defun clipboard-synchronize ())
  (defun clipboard-synchronize ()
    (let*
	((file (expand-file-name clipboard-file-name))
	 (current-mtime (nth 5 (file-attributes file))))

      (unless (equal clipboard-mtime current-mtime)
	(and
	 (setq clipboard-mtime current-mtime)
	 (with-temp-buffer
	   (set-buffer-file-coding-system 'sjis-dos)
	   (erase-buffer)
	   (insert-file-contents file)
	   (set-next-selection-coding-system 'sjis-dos)
	   (kill-ring-save (point-min) (point-max)))))))

  (run-with-idle-timer clipboard-synchronize-interval
		       'repeat
		       'clipboard-synchronize))