;-*- emcs-lisp -*-

;(setq howm-menu-lang 'en)
(setq howm-menu-lang 'ja)
(global-set-key "\C-c,," 'howm-menu)

(defun my-save-and-kill-buffer ()
  (interactive)
  (save-buffer)
  (kill-buffer nil))

(global-set-key "\C-c\C-c" 'my-save-and-kill-buffer)
