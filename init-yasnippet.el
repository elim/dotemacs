;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode t -*-
;; $Id$

(when (require 'yasnippet nil t)
  (defvar yas/load-directory (list (expand-file-name
				    "~/src/elisps/yasnippet/snippets/")))
  (yas/initialize))
