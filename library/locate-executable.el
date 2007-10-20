;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; based upon
;; http://d.hatena.ne.jp/elim/20071014/1192380471
(defun locate-executable (basename)
  (let
      ((suffix (list nil ".exe" ".com" ".cmd" ".bat"))
       (exist-flag nil)
       (return-value nil))
    (dolist (s suffix)
      (unless exist-flag
	(setq return-value
	      (locate-library (concat basename s) nil exec-path))
	(when return-value
	  (when (file-executable-p return-value)
	    (setq exist-flag t)))))
    return-value))
