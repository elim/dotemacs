;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(defun locate-executable (name)
  (if (and (boundp 'exec-suffixes) (fboundp 'locate-file)) ;; emacs22 feature
      (locate-file name exec-path exec-suffixes 'file-executable-p)
    (let
	((exec-suffixes (list nil ".exe" ".com" ".cmd" ".bat")))
	(caar
	 (remove nil
		 (mapcar #'(lambda (path)
			     (remove nil
				     (mapcar #'(lambda (suffix)
						 (locate-library
						  (concat name suffix) nil (list path)))
					     exec-suffixes)))
			 exec-path))))))