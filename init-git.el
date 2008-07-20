;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'git nil t)
  (autoload-if-found 'git-blame-mode "git-blame"
                     "Minor mode for incremental blame for Git." t)

  (when (locate-library "vc-git")
    (add-to-list 'vc-handled-backends 'GIT))

  (add-hook 'dired-mode-hook
            '(lambda ()
               (define-key dired-mode-map "V" 'git-status)
               (turn-on-font-lock))))

(when (locate-executable "git")
  (defmacro git (&rest arg)
    `(call-process "git" nil t nil ,@arg))

  (defun git-sync (directory)
    (with-temp-buffer ;; preserve pwd
      (cd directory)
      (git "add" ".")
      (git "pull")
      (git "commit" "-m" (format-time-string
                          "Snapshot %b.%d,%Y(%a) %H:%M:%S"))
      (git "push"))))

