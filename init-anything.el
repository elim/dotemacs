;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'anything nil t)
  (when (executable-find "w3m")
    (require 'anything-config nil t))
  (require 'anything-startup nil t)

  (when (require 'anything-complete nil t)
    (anything-lisp-complete-symbol-set-timer 150)

    (setq anything-sources
          (list anything-c-source-buffers
                anything-c-source-file-name-history
                anything-c-source-info-pages
                anything-c-source-man-pages
                anything-c-source-locate
                anything-c-source-emacs-commands))

    (mapc '(lambda (key)
             (global-set-key key 'anything))
          (list
           [(control ?:)]
           [(control \;)]
           [(control x)(b)]
           [(control x)(control :)]
           [(control x)(control \;)]))))