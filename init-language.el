;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;;; Mule-UCS settings.
(when (>= 21 emacs-major-version)
  (require 'un-define nil t) ; Unicode
  (require 'jisx0213 nil t)) ; JIS X 0213

;;; UTF-8 environment.
(defun setup-default-coding-systems (language-name target-list)
  (let
      ((my-default-coding-system language-name)
       (funciion-name nil))

    (dolist (f target-list)
      (setq funciion-name (intern (concat "set-" f)))
      (when (functionp funciion-name)
	(funcall funciion-name my-default-coding-system))
      (set (intern f) my-default-coding-system))))

(setup-default-coding-systems
 'utf-8 (list
	 "language-environment"))

(setup-default-coding-systems
 (cond
  ((and (featurep 'mac-carbon)
	(featurep 'utf-8m)) 'utf-8m)
  ((featurep 'meadow)  'sjis-dos)
  (t 'utf-8)) (list
	       "default-coding-systems"
	       "buffer-file-coding-system"
	       "terminal-coding-system"
	       "file-name-coding-system"
	       "keyboard-coding-system"
	       "clipboard-coding-system"))

;;; modified coding detection priority. (low => high)
(dolist (c (list 'shift_jis 'iso-2022-jp 'euc-jp 'utf-8))
  (prefer-coding-system c))