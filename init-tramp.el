;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(and (require 'tramp nil t)
     (setq
      tramp-verbose 10
      tramp-debug-buffer t
      tramp-methods
      (mapcar (lambda (x)
                (if (string-equal (car x) "sudo")
                    '("sudo"
                      (tramp-connection-function tramp-open-connection-su)
                      (tramp-login-program "env")
                      (tramp-login-args ("SHELL=/bin/sh" "sudo"
                                         "-u" "%u" "-s"
                                         "-p" "Password:"))
                      (tramp-copy-program nil)
                      (tramp-remote-sh "/bin/sh")
                      (tramp-copy-args nil)
                      (tramp-copy-keep-date-arg nil)
                      (tramp-password-end-of-line nil))
                  x)) tramp-methods))

     (when (boundp 'tramp-multi-connection-function-alist)
       (setq tramp-default-method "sshx")
       (add-to-list
        'tramp-multi-connection-function-alist
        '("sshx" tramp-multi-connect-rlogin
          "ssh -t -t %h -l %u /bin/sh%n"))))