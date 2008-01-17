;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=save%20scratch

(defvar scratch-file-name "~/.scratch")

(defun save-scratch-data ()
  (let ((str (progn
	       (set-buffer (get-buffer "*scratch*"))
	       (buffer-substring-no-properties
		(point-min) (point-max))))
	(file scratch-file-name))
    (if (get-file-buffer (expand-file-name file))
	(setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect file)))
    (set-buffer buf)
    (erase-buffer)
    (insert str)
    (save-buffer)))

(add-hook 'kill-emacs-hook
	  (lambda ()
	    (save-scratch-data)))

(defun read-scratch-data ()
  (let ((file scratch-file-name))
    (when (file-exists-p file)
      (set-buffer (get-buffer "*scratch*"))
      (erase-buffer)
      (insert-file-contents file))))

(add-hook 'emacs-startup-hook
	  (lambda ()
	    (read-scratch-data)))

(defadvice elscreen-kill (before call-save-scratch-data
				 activate)
  (when (equal "*scratch*" (buffer-name))
    (save-scratch-data)))

(defadvice elscreen-default-window-configuration (around
						  call-read-scratch-data
						  activate)
  (if (and (equal "*scratch*" elscreen-default-buffer-name)
	   (not (get-buffer elscreen-default-buffer-name)))
      (progn
	ad-do-it
	(read-scratch-data))
    ad-do-it))