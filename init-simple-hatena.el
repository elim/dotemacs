;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://coderepos.org/share/wiki/SimpleHatenaMode
(when (require 'simple-hatena-mode nil t)
  (setq simple-hatena-root "~/.howm/hatena"
        simple-hatena-default-id "elim"
        simple-hatena-default-group "elim"
        simple-hatena-use-timestamp-permalink-flag t
        simple-hatena-time-offset 6
        simple-hatena-option-debug-flag nil)

  (when (member '("utf-8-unix") coding-system-alist)
    (add-hook 'simple-hatena-mode-hook
              '(lambda ()
                 (setq buffer-file-coding-system 'utf-8-unix))))

  (let
      ((helper (or (require 'simple-hatenahelper-mode nil t)
                   (require 'hatenahelper-mode nil t))))

    (when helper
      (add-hook 'simple-hatena-mode-hook
                `(lambda ()
                   (,helper 1))))))