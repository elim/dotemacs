;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;;; vars
; default-buffer-file-coding-system
; default-process-coding-system
; default-file-name-coding-system
; default-terminal-coding-system
; default-keyboard-coding-system
; coding-category-list

;;; Mule-UCS settings.
(when (>= 21 emacs-major-version)
  (require 'un-define nil t) ; Unicode
  (require 'jisx0213 nil t)) ; JIS X 0213

(when (member '("utf-8-unix") coding-system-alist)
  (set-language-environment 'utf-8)

  ;;; modified coding detection priority. (low => high)
  (mapc  #'prefer-coding-system
	 '(shift_jis iso-2022-jp euc-jp utf-8))

  ;;; http://www.pqrs.org/~tekezo/emacs/doc/wide-character/index.html
  (when (functionp #'utf-translate-cjk-set-unicode-range)
    (utf-translate-cjk-set-unicode-range
     '((#x00a2 . #x00a3) ; ¢, £
       (#x00a7 . #x00a8) ; §, ¨
       (#x00ac . #x00ac) ; ¬
       (#x00b0 . #x00b1) ; °, ±
       (#x00b4 . #x00b4) ; ´
       (#x00b6 . #x00b6) ; ¶
       (#x00d7 . #x00d7) ; ×
       (#X00f7 . #x00f7) ; ÷
       (#x0370 . #x03ff) ; Greek and Coptic
       (#x0400 . #x04FF) ; Cyrillic
       (#x2000 . #x206F) ; General Punctuation
       (#x2100 . #x214F) ; Letterlike Symbols
       (#x2190 . #x21FF) ; Arrows
       (#x2200 . #x22FF) ; Mathematical Operators
       (#x2300 . #x23FF) ; Miscellaneous Technical
       (#x2500 . #x257F) ; Box Drawing
       (#x25A0 . #x25FF) ; Geometric Shapes
       (#x2600 . #x26FF) ; Miscellaneous Symbols
       (#x2e80 . #xd7a3) ; East Asian Scripts
       (#xff00 . #xffef)))))

(when (and (not window-system)
	   (string-equal "screen" (getenv "TERM")))
  (and
   (call-process "screen" nil nil nil "-X" "eval" "encoding euc"
		 "cjkwidth on")
   (mapc #'(lambda (func)
	     (funcall func 'euc-jp))
	 (list #'set-terminal-coding-system
	       #'set-keyboard-coding-system))))