;-*- emacs-lisp -*-
;$Id$

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; coding 判定の順を指定. 
;; 実行毎に先頭に追加される. 
(prefer-coding-system 'shift_jis)
(prefer-coding-system 'iso-2022-jp)
(prefer-coding-system 'euc-jp)


(if (featurep 'meadow)
    (progn
      (set-clipboard-coding-system 'shift_jis-dos)
      (setq file-name-coding-system 'shift_jis-dos))
  (setq file-name-coding-system 'utf-8))




