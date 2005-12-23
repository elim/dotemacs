;-*- emacs-lisp -*-
;$Id$

(when (locate-library "mwheel")
  (require 'mwheel)
  (setq mwheel-follow-mouse t))
