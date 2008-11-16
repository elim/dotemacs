;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(and (require 'tramp nil t)
     (setq
      tramp-verbose 10
      tramp-debug-buffer t
      tramp-methods (append
                     '(("sudo"
                        (tramp-connection-function  tramp-open-connection-su)
                        (tramp-login-program "env")
                        (tramp-login-args ("SHELL=/bin/sh" "sudo"
                                           "-u" "%u" "-s"
                                           "-p" "Password:"))
                        (tramp-copy-program nil)
                        (tramp-remote-sh "/bin/sh")
                        (tramp-copy-args nil)
                        (tramp-copy-keep-date-arg nil)
                        (tramp-password-end-of-line nil)))
                     tramp-methods)
;;       ;; http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=175346
;;       ;; http://yoichi.geiin.org/d/?date=20030328#p01
;;       auto-save-file-name-transforms
;;       `(("\\`/[^/]*:\\(.+/\\)*\\(.*\\)"
;;          ,(expand-file-name "\\2" temporary-file-directory))))
)
     ;; http://aligach.net/diary/20071022.html
     (when (boundp 'tramp-multi-connection-function-alist)
       (setq tramp-default-method "sshx")
       (add-to-list
        'tramp-multi-connection-function-alist
        '("sshx" tramp-multi-connect-rlogin
          "ssh -t -t %h -l %u /bin/sh%n"))))