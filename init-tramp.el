;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'tramp nil t)
  ;; http://aligach.net/diary/20071022.html
  (setq tramp-default-method "sshx")
  (add-to-list
   'tramp-multi-connection-function-alist
   '("sshx" tramp-multi-connect-rlogin "ssh -t -t %h -l %u /bin/sh%n"))

  ;; http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=175346
  ;; http://yoichi.geiin.org/d/?date=20030328#p01
  (setq auto-save-file-name-transforms
	`(("\\`/[^/]*:\\(.+/\\)*\\(.*\\)"
	   ,(expand-file-name "\\2" temporary-file-directory)))))
