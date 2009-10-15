;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://d.hatena.ne.jp/higepon/20061230/1167447339
(when (require 'session nil t)
  (setq history-length t
        session-initialize '(de-saveplace session keys menus places)
        session-globals-include '((kill-ring 255)
                                  (session-file-alist 255 t)
                                  (file-name-history 255))
        session-globals-max-size 1024
        session-globals-max-string 1024
        session-save-file (expand-file-name
                           "session-save.el" user-emacs-directory))
  (add-hook 'after-init-hook 'session-initialize))
