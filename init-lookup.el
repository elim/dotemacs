;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (autoload-if-found 'lookup "lookup" nil t)
  (autoload-if-found 'lookup-word "lookup" nil t)
  (autoload-if-found 'lookup-region "lookup" nil t)
  (autoload-if-found 'lookup-pattern "lookup" nil t)

  (define-key ctl-x-map "l" 'lookup)
  (define-key ctl-x-map "e" 'lookup-word)
  (define-key ctl-x-map "y" 'lookup-region)
  ;; (define-key ctl-x-map "\C-y" 'lookup-pattern)

  ;;   (when window-system
  ;;     (setq lookup-use-bitmap t))
  (setq lookup-use-bitmap nil)
  (setq lookup-open-function 'lookup-other-frame)
  (setq lookup-frame-alist default-frame-alist)

  (when (featurep 'meadow)
    (setq ndspell-ispell-program
	  "c:/Cygwin/opt/ispell-3.3.01/bin/ispell.exe"))

  (setq my-ndtp-server-definition
	(list 'ndtp (cond
		     ((string-match my-domestic-domain system-name)
		      "idea")
		     (t
		      "localhost")) :port 2010))

  (setq lookup-search-agents
	(list
	 my-ndtp-server-definition
	 '(ndspell))))