;-*- emacs-lisp -*-
; $Id$

(autoload 'lookup "lookup" nil t)
(autoload 'lookup-word "lookup" nil t)
(autoload 'lookup-region "lookup" nil t)
(autoload 'lookup-pattern "lookup" nil t)

(define-key ctl-x-map "l" 'lookup)
(define-key ctl-x-map "e" 'lookup-word)
(define-key ctl-x-map "y" 'lookup-region)
;(define-key ctl-x-map "\C-y" 'lookup-pattern)

(setq lookup-use-bitmap nil)

;(setq lookup-open-function 'lookup-other-frame)
(setq lookup-frame-alist
      '((menu-bar-lines . 0)
	(width . 80) (height . 35)
	(top . 5) (left . -10)
	(vertical-scroll-bars . nil)))

(if (featurep 'meadow)
    (progn(setq ndspell-ispell-program
		"c:/Cygwin/opt/ispell-3.3.01/bin/ispell.exe")
	  (setq ndspell-grep-program
		"c:/Cygwin/usr/bin/grep.exe"))
  nil)

(if (featurep 'meadow)
    (setq lookup-search-agents
	  '((ndtp "localhost" :port 12010)
	    (ndspell)))
  (setq lookup-search-agents
	'((ndtp "elim.teroknor.org" :port 2010)
	  (ndspell))))