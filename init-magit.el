;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload 'magit-status "magit" nil t)
  (add-to-list 'process-coding-system-alist '("git" . utf-8))
  (add-hook 'dired-mode-hook
            (lambda ()
              (define-key dired-mode-map "V" 'magit-status))))
  

  (add-to-list 'auto-coding-alist '("COMMIT_EDITMSG" . utf-8-unix))
