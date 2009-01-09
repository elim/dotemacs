;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://coderepos.org/share/wiki/SimpleHatenaMode
(when (require 'simple-hatena-mode nil t)
  (setq simple-hatena-root "~/.howm/hatena"
        simple-hatena-default-id "elim"
        simple-hatena-default-group "elim"
        simple-hatena-use-timestamp-permalink-flag t
        simple-hatena-time-offset 6
        simple-hatena-option-debug-flag nil

        file-coding-system-alist
        (append
         `((,simple-hatena-filename-regex utf-8-unix . utf-8-unix))
         file-coding-system-alist))

  (add-hook 'simple-hatena-before-submit-hook
            '(lambda ()
               (setq buffer-file-coding-system 'utf-8-unix)))
  
  (defadvice simple-hatena-internal-safe-find-file (after
                                                    insert-fixed-expression
                                                    activate)
    (unless (file-exists-p (buffer-file-name))
      (insert "delete\n*")))

  (defadvice simple-hatena-internal-safe-find-file (around
                                                    force-r/w-utf8 (filename)
                                                    activate)
    (let*
        ((coding-system 'utf-8-unix)
         (coding-system-for-read coding-system)
         (coding-system-for-write coding-system)
         (coding-system-require-warning t))
      ad-do-it))
          

  (let
      ((helper (or (require 'simple-hatenahelper-mode nil t)
                   (require 'hatenahelper-mode nil t))))

    (when helper
      (add-hook 'simple-hatena-mode-hook
                `(lambda ()
                   (,helper 1))))))


