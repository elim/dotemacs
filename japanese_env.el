;-*- emcs-lisp -*-
; 日本語環境
(set-language-environment "Japanese")
(set-default-coding-systems 'euc-japan-unix)
(set-keyboard-coding-system 'euc-japan-unix)
(if (not window-system) (set-terminal-coding-system 'euc-japan-unix))

; 日本語 info が文字化けしないように
(auto-compression-mode t)

; 日本語 grep
(if (file-exists-p "/usr/bin/jgrep")
    (setq grep-command "jgrep -n -e ")
)
