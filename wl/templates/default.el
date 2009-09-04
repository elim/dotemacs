;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(add-to-list
 'wl-template-alist
 `(,(file-name-sans-extension
    (file-name-nondirectory load-file-name))
   ("Organization" . nil)))