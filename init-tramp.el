;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(and (require 'tramp nil t)
     (setq
      ;; http://aligach.net/diary/20071022.html
      tramp-default-method "sshx"
      ;; http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=175346
      ;; http://yoichi.geiin.org/d/?date=20030328#p01
      auto-save-file-name-transforms
      `(("\\`/[^/]*:\\(.+/\\)*\\(.*\\)"
	 ,(expand-file-name "\\2" temporary-file-directory))))
     (boundp 'tramp-multi-connection-function-alist)
     (add-to-list
      'tramp-multi-connection-function-alist
      '("sshx" tramp-multi-connect-rlogin "ssh -t -t %h -l %u /bin/sh%n")))

