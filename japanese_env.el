;-*- emcs-lisp -*-
; ���ܸ�Ķ�
(set-language-environment "Japanese")
(set-default-coding-systems 'euc-japan-unix)
(set-keyboard-coding-system 'euc-japan-unix)
(if (not window-system) (set-terminal-coding-system 'euc-japan-unix))

; ���ܸ� info ��ʸ���������ʤ��褦��
(auto-compression-mode t)

; ���ܸ� grep
(if (file-exists-p "/usr/bin/jgrep")
    (setq grep-command "jgrep -n -e ")
)
