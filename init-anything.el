;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-
;;; $Id$

(when (and (require 'anything nil t)
           (require 'anything-config nil t))
  (mapc '(lambda (key)
           (global-set-key key 'anything))
        (list
         [(control ?:)]
         [(control \;)]
         [(control x)(b)]
         [(control x)(control :)]
         [(control x)(control \;)])))
