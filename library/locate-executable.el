;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; based upon
;; http://d.hatena.ne.jp/elim/20071014/1192380471
(defun locate-executable (basename)
  (let
      ((suffix (list nil ".exe" ".com" ".cmd" ".bat"))
       (return-value nil))

    (dolist (s suffix)
      (setq return-value
	    (or return-value
		(locate-library (concat basename s) nil exec-path)))
	(when return-value
	  (unless (file-executable-p return-value)
	    (setq return-value nil))))
    return-value))
