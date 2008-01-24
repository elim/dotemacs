;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(defun locate-executable (arg)
  (if (and (boundp 'exec-suffixes) (fboundp 'locate-file)) ;; emacs22 feature
      (locate-file arg exec-path exec-suffixes 'file-executable-p)
    (let
	((name arg)
	 (exec-suffixes (list nil ".exe" ".com" ".cmd" ".bat")))
      (car
       (remove nil
	       (mapcar
		'(lambda (arg)
		   (locate-library
		    (concat name arg) nil exec-path)) exec-suffixes))))))

