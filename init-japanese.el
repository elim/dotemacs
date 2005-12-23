;; -*- emacs-lisp -*-
; $Id$

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system
 (cond
  ((eq window-system 'mac)
   'sjis-mac)
  ((featurep 'meadow)
   'sjis-dos)
  (t
   'utf-8)))

(set-clipboard-coding-system
 (cond
  ((eq window-system 'mac)
   'sjis-mac)
  ((featurep 'meadow)
   'sjis-dos)
  (t
   'utf-8)))

(setq file-name-coding-system
      (cond
       ((featurep 'meadow)
	'sjis-dos)
       (t
	'utf-8)))

(setq default-buffer-file-coding-system 'utf-8)

;; coding 判定の順を指定.
;; 実行毎に先頭に追加される.
(prefer-coding-system 'shift_jis)
(prefer-coding-system 'iso-2022-jp)
(prefer-coding-system 'euc-jp)
(prefer-coding-system 'utf-8)

