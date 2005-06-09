;-*- emacs-lisp -*-
;$Id$

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setq default-buffer-file-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)

(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq prefer-coding-system 'utf-8)

(if (featurep 'meadow)
    (set-clipboard-coding-system 'shift_jis-dos))


