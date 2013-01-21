;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-


(when (require 'flymake nil t)
  (setq flymake-gui-warnings-enabled nil)
  (set-face-background 'flymake-errline "red4")
  (set-face-foreground 'flymake-errline "black")
  (set-face-background 'flymake-warnline "yellow")
  (set-face-foreground 'flymake-warnline "black")

  ;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
  (defun flymake-display-err-minibuf ()
    "Displays the error/warning for the current line in the minibuffer"
    (interactive)
    (let* ((line-no
            (flymake-current-line-no))
           (line-err-info-list
            (nth 0 (flymake-find-err-info flymake-err-info line-no)))
           (count
            (length line-err-info-list)))
      (while (> count 0)
        (when line-err-info-list
          (let* ((file
                  (flymake-ler-file (nth (1- count) line-err-info-list)))
                 (full-file
                  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
                 (text
                  (flymake-ler-text (nth (1- count) line-err-info-list)))
                 (line
                  (flymake-ler-line (nth (1- count) line-err-info-list))))
            (message "[%s] %s" line text)))
        (setq count (1- count)))))

  (defadvice flymake-report-status
    (before flymake-quite-report-status (e-w &optional status) activate)
    (when (not e-w)
      (progn
        (flymake-mode 0)
        (flymake-log
         0 (concat "Switched Off Flymake mode due to unknown"
                   "fatal status (maybe tramp is running)"))))))