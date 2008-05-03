;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

(when (require 'find-recursive nil t)
  (require 'snippet nil t)
  (require 'rails nil t)

  (and (locate-executable "fri")
       (setq rails-ri-command "fri"))

  (setq rails-always-use-text-menus t)

  (mapc (lambda (pair)
	  (apply #'define-key rails-minor-mode-map pair))
	'(([(control c)(t)] rails-controller-layout:toggle-action-view)
	  ([(control c)(control p)] rails-lib:run-primary-switch)
	  ([(control c)(control n)] rails-lib:run-secondary-switch))))
