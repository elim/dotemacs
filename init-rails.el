;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(and (require 'find-recursive nil t)
     (require 'snippet nil t)
     (require 'rails nil t)

     (define-key rails-minor-mode-map
       "\C-c\C-p" 'rails-lib:run-primary-switch)
     (define-key rails-minor-mode-map
       "\C-c\C-n" 'rails-lib:run-secondary-switch))