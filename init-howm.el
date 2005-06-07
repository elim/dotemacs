;-*- emacs-lisp -*-
; $Id$

(setq howm-menu-lang 'ja)
(global-set-key "\C-c,," 'howm-menu)
(autoload 'howm-menu "howm" "Hitori Otegaru Wiki Modoki" t)

(defun my-save-and-kill-buffer ()
  (interactive)
  (save-buffer)
  (kill-buffer nil))

(global-set-key "\C-c\C-c" 'my-save-and-kill-buffer)

(add-hook 'howm-view-open-hook
	  (lambda ()
	    (setq buffer-file-coding-system 'utf-8-unix)))


(add-hook 'howm-create-file-hook
	  (lambda ()
	    (setq buffer-file-coding-system 'utf-8-unix)))

(defadvice howm-call-process (around set-coding-system activate)
  ;; cf. M-x list-conding-systems
  (let* ((c 'utf-8-unix)
	 (coding-system-for-write c) ;; これも必要?
	 (coding-system-for-read c))
    ad-do-it))