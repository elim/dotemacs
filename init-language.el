;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;;; Mule-UCS settings.
(when (>= 21 emacs-major-version)
  (require 'un-define nil t) ; Unicode
  (require 'jisx0213 nil t)) ; JIS X 0213

;;; Japanese environment.
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

(let
    ((my-default-coding-system
      (cond
       ((featurep 'mac-carbon) 'sjis-mac)
       ((featurep 'meadow)  'sjis-dos)
       (t 'utf-8))))
  (progn
    (set-keyboard-coding-system my-default-coding-system)
    (set-clipboard-coding-system my-default-coding-system)
    (set-file-name-coding-system my-default-coding-system)
    (setq default-buffer-file-coding-system my-default-coding-system)))

;;; modified coding priority. (low => high)
(dolist (c (list 'shift_jis 'iso-2022-jp 'euc-jp 'utf-8))
  (prefer-coding-system c))