;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; based upon
;; http://coderepos.org/share/wiki/SimpleHatenaMode

(when (require 'simple-hatena-mode nil t)
  (when (require 'hatenahelper-mode nil t)
    (add-hook 'simple-hatena-mode-hook
	      '(lambda ()
		 (hatenahelper-mode 1))))

  (setq simple-hatena-default-id "elim"
	simple-hatena-default-group "elim"
	simple-hatena-use-timestamp-permalink-flag nil
	simple-hatena-time-offset 6
	simple-hatena-option-debug-flag t))
