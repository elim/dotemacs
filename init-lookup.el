;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (mapc '(lambda (lib)
               (apply #'autoload-if-found lib))
            (list
             '(lookup "lookup" nil t)
             '(lookup-word "lookup" nil t)
             '(lookup-region "lookup" nil t)
             '(lookup-pattern "lookup" nil t)))

  (define-key ctl-x-map "l" 'lookup)
  (define-key ctl-x-map "e" 'lookup-word)
  (define-key ctl-x-map "y" 'lookup-region)
  ;; (define-key ctl-x-map "\C-y" 'lookup-pattern)

  (setq lookup-use-bitmap (if window-system t nil)
        lookup-use-bitmap nil
        lookup-open-function 'lookup-other-frame
        lookup-frame-alist default-frame-alist

        ndspell-ispell-program
        (if (require 'ispell nil t)
          ispell-program-name
          ndspell-ispell-program)

        ndtp-server-definition
        (list 'ndtp "localhost" :port 2010)

        lookup-search-agents
        (list ndtp-server-definition
              '(ndspell))))