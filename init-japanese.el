;-*- emacs-lisp -*-
;$Id$

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'euc-jp-unix)

(if (featurep 'meadow)
    (progn
      (set-clipboard-coding-system 'shift_jis-dos)
      (setq file-name-coding-system 'shift_jis-dos))
  (setq file-name-coding-system 'utf-8))




