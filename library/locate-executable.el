;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; based upon
;; http://d.hatena.ne.jp/elim/20071014/1192380471

(defun locate-executable (name)
  (if (boundp 'exec-suffixes) ;; emacs22 feature
      (locate-file name exec-path exec-suffixes 'file-executable-p)
    (let
	((exec-suffixes (list nil ".exe" ".com" ".cmd" ".bat"))
	 (found nil))
      (require 'cl nil t)
      (dolist (s exec-suffixes found)
	(unless found
	  (setq found
		(locate-library (concat name s) nil exec-path))
	  (unless (and found (file-executable-p found))
	    (setq found nil))))
      found)))