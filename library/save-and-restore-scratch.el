;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=save%20scratch

(defun save-scratch-data ()
  (let ((str (progn
	       (set-buffer (get-buffer "*scratch*"))
	       (buffer-substring-no-properties
		(point-min) (point-max))))
	(file "~/.scratch"))
    (if (get-file-buffer (expand-file-name file))
	(setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect file)))
    (set-buffer buf)
    (erase-buffer)
    (insert str)
    (save-buffer)))

;(defadvice save-buffers-kill-emacs
;  (before save-scratch-buffer activate)
;  (save-scratch-data))

(add-hook 'kill-emacs-hook
	  (lambda ()
	    (save-scratch-data)))

(defun read-scratch-data ()
  (let ((file "~/.scratch"))
    (when (file-exists-p file)
      (set-buffer (get-buffer "*scratch*"))
      (erase-buffer)
      (insert-file-contents file))))

(add-hook 'emacs-startup-hook
	  (lambda ()
	    (read-scratch-data)))