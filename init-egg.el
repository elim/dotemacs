;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'egg nil t)
  (load "egg-grep" t)
  (add-to-list 'process-coding-system-alist '("git" . utf-8))
  (add-hook 'dired-mode-hook
            (lambda ()
              (define-key dired-mode-map "V" 'egg-status)))
  

(and nt-p
     (executable-find "chmod")
     (add-hook 'after-save-hook
               (lambda ()
                 (let*
                     ((git-dir (egg-git-dir))
                      (base-dir (and git-dir
                                     (string-match "\\(.+\\).git" git-dir)
                                     (match-string 1 git-dir)))
                      (file-name (and base-dir
                                      (string-match (format "%s\\(.+\\)" base-dir)
                                                    (buffer-file-name))
                                      (match-string 1 (buffer-file-name))))
                      (old-mode (and file-name
                                     (with-temp-buffer
                                       (call-process "git" nil t t "diff" file-name)
                                       (goto-char (point-min))
                                       (when (re-search-forward "^old mode.+\\([0-9]..\\)$" nil t)
                                         (match-string 1))))))

                   (when old-mode
                     (call-process "chmod" nil t t old-mode (buffer-file-name))))))))