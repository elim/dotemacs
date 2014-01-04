;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://d.hatena.ne.jp/rubikitch/20080227/1204051280
(when (require 'align nil t)

  (add-to-list 'align-rules-list
               '(ruby-comma-delimiter
                 (regexp . ",\\(\\s-*\\)[^# \t\n]")
                 (repeat . t)
                 (modes  . '(ruby-mode))))

  (add-to-list 'align-rules-list
               '(ruby-hash-literal
                 (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(ruby-mode))))

  (add-to-list 'align-rules-list
               '(ruby-assignment-literal
                 (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(ruby-mode))))

  (add-to-list 'align-rules-list
               '(javascript-assignment-literal
                 (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(javascript-mode))))

  (add-to-list 'align-rules-list
               '(javascript-assignment-literal
                 (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(js2-mode))))

  (add-to-list 'align-rules-list
               '(ruby-comma-delimiter
                 (regexp . ",\\(\\s-*\\)[^# \t\n]")
                 (repeat . t)
                 (modes  . '(ruby-mode))))

  (add-to-list 'align-rules-list
               '(php-array-literal
                 (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(php-mode))))

  (add-to-list 'align-rules-list
               '(php-assignment-literal
                 (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(php-mode))))

  (add-to-list 'align-rules-list
               '(php-comma-delimiter
                 (regexp . ",\\(\\s-*\\)[^/ \t\n]")
                 (justify .t)
                 (tab-stop . nil)
                 (modes . '(php-mode))))

  (add-to-list 'align-rules-list
               '(web-array-literal
                 (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(web-mode))))

  (add-to-list 'align-rules-list
               '(web-assignment-literal
                 (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(web-mode))))

  (add-to-list 'align-rules-list
               '(web-comma-delimiter
                 (regexp . ",\\(\\s-*\\)[^/ \t\n]")
                 (justify .t)
                 (tab-stop . nil)
                 (modes . '(web-mode))))

  (add-to-list 'align-rules-list
               '(puppet-assignment-literal
                 (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(puppet-mode))))

  (add-to-list 'align-rules-list
               '(puppet-set-value-literal
                 (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
                 (repeat . t)
                 (modes  . '(puppet-mode)))))
