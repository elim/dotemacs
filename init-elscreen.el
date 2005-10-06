; -*- emacs-lisp -*-
; $Id$

(eval-safe
 (unload-feature 'elscreen))

(setq elscreen-prefix-key "\C-l")
(eval-safe (require 'elscreen))
(eval-safe (require 'elscreen-wl))
(eval-safe (require 'elscreen-w3m))
(eval-safe (require 'elscreen-dired))

