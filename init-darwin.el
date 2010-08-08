;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(and
 darwin-p
 (or
  (eq window-system 'mac)
  (eq window-system 'ns))
 (setq mac-allow-anti-aliasing nil
       mac-pass-control-to-system nil
       mac-pass-command-to-system nil
       mac-pass-option-to-system nil
       mac-option-modifier nil
       mac-function-modifier nil
       mac-option-modifier 'meta

       ns-antialias-text nil
       ns-command-modifier 'meta
       x-select-enable-clipboard nil
       x-select-enable-primary t
       select-active-regions nil)

 (define-key global-map [ns-drag-file] 'ns-find-file))
