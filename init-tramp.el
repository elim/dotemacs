;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(and (require 'tramp nil t)
     (setq
      tramp-verbose 10 ;; default => 9
      tramp-debug-buffer nil
      tramp-default-method "sshx")


     (defadvice auto-save-buffers (around
                                   auto-save-buffers-exclude-tramp
                                   activate)
       (unless (string-match tramp-file-name-regexp buffer-file-name)
         ad-do-it))

     (when (boundp 'tramp-default-proxies-alist)
       (mapc (lambda (x)
               (add-to-list 'tramp-default-proxies-alist x))
             (list
              '("\\'" "\\`root\\'" "/sshx:%h:")
              `(,(format "%s\\'" (car (split-string (system-name) "\\."))
                         "\\`root\\'" nil))
              '("localhost\\'" "\\`root\\'" nil))))


     (when (boundp 'tramp-multi-connection-function-alist)
       (add-to-list
        'tramp-multi-connection-function-alist
        '("sshx" tramp-multi-connect-rlogin
          "ssh -t -t %h -l %u /bin/sh%n"))))