;-*- emcs-lisp -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'lookup "lookup" nil t)
(autoload 'lookup-word "lookup" nil t)
(autoload 'lookup-region "lookup" nil t)
(autoload 'lookup-pattern "lookup" nil t)

(define-key ctl-x-map "l" 'lookup)
(define-key ctl-x-map "e" 'lookup-word)
(define-key ctl-x-map "y" 'lookup-region)
;(define-key ctl-x-map "\C-y" 'lookup-pattern)

(setq lookup-use-bitmap nil)

(setq lookup-open-function 'lookup-other-frame)
(setq lookup-frame-alist
      '((menu-bar-lines . 0)
	(width . 80) (height . 35)
	(top . 5) (left . -10)
	(vertical-scroll-bars . nil)))

(setq lookup-search-agents
      '((ndtp "localhost")
	(ndspell)))
