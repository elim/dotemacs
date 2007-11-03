;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(require 'cl nil t)

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

;;; http://www.pqrs.org/~tekezo/emacs/doc/wide-character/index.html
(when (functionp 'utf-translate-cjk-set-unicode-range)
  (utf-translate-cjk-set-unicode-range
   '((#x00a2 . #x00a3)                    ; ¢, £
     (#x00a7 . #x00a8)                    ; §, ¨
     (#x00ac . #x00ac)                    ; ¬
     (#x00b0 . #x00b1)                    ; °, ±
     (#x00b4 . #x00b4)                    ; ´
     (#x00b6 . #x00b6)                    ; ¶
     (#x00d7 . #x00d7)                    ; ×
     (#X00f7 . #x00f7)                    ; ÷
     (#x0370 . #x03ff)                    ; Greek and Coptic
     (#x0400 . #x04FF)                    ; Cyrillic
     (#x2000 . #x206F)                    ; General Punctuation
     (#x2100 . #x214F)                    ; Letterlike Symbols
     (#x2190 . #x21FF)                    ; Arrows
     (#x2200 . #x22FF)                    ; Mathematical Operators
     (#x2300 . #x23FF)                    ; Miscellaneous Technical
     (#x2500 . #x257F)                    ; Box Drawing
     (#x25A0 . #x25FF)                    ; Geometric Shapes
     (#x2600 . #x26FF)                    ; Miscellaneous Symbols
     (#x2e80 . #xd7a3) (#xff00 . #xffef))))
