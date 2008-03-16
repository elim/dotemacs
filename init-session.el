;; -*- emacs-lisp -*-
;; $Id$

;; http://d.hatena.ne.jp/higepon/20061230/1167447339
(when (require 'session nil t)
  (setq history-length t)
  (setq session-initialize '(de-saveplace session keys menus places))
  (setq session-globals-include '((kill-ring 255)
				  (session-file-alist 255 t)
				  (file-name-history 255)))
  (setq session-globals-max-size 1024)
  (setq session-globals-max-string 1024)
  (setq session-save-file (expand-file-name "session-save.el" base-directory))
  (add-hook 'after-init-hook 'session-initialize))
