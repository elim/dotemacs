;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$


(when (require 'hideshow nil t)
  (define-key hs-minor-mode-map
    [(control c)(control meta c)] 'hs-toggle-hiding))
