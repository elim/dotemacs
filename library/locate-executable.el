;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; based upon
;; http://d.hatena.ne.jp/elim/20071014/1192380471
(require 'cl nil t)

(defun locate-executable (basename)
  (let
      ((suffix (list nil ".exe" ".com" ".cmd" ".bat"))
       (return-value nil))

    (dolist (s suffix return-value)
      (setq return-value
	    (or return-value
		(locate-library (concat basename s) nil exec-path)))
      (when return-value
	(if (file-executable-p return-value)
	    (return return-value)
	  (setq return-value nil))))))