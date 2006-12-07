;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'w3m-load nil t)
  (autoload-if-found
   'w3m "w3m" "*Interface for w3m on Emacs." t)
  (autoload-if-found
   'w3m-find-file "w3m" "*w3m interface function for local file." t)
  (autoload-if-found
   'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
  (autoload-if-found
   'w3m-search "w3m-search" "*Search QUERY using SEARCH-ENGINE." t)
  (autoload-if-found
   'w3m-weather "w3m-weather" "*Display weather report." t)
  (autoload-if-found
   'w3m-antenna "w3m-antenna" "*Report chenge of WEB sites." t)

  (require 'w3m-wget nil t)

  (setq w3m-search-default-engine "google-ja")
  (setq w3m-pop-up-frames nil)
  (setq w3m-tab-width 4)
  (setq w3m-use-cookies t)
  (setq w3m-use-tab t)
  (setq w3m-use-toolbar t)
  (setq w3m-home-page "about:blank")
  (setq w3m-weather-default-area "道央・石狩")

  (global-set-key "\C-cs" 'w3m-search)

  (eval-after-load "w3m-search"
    (progn
      '(add-to-list
	'w3m-search-engine-alist
	'("google-ja"
	  "http://www.google.com/search?q=%s&hl=ja&lr=lang_ja&ie=UTF-8"
	  utf-8)
	'("wdic"
	  "http://www.wdic.org/?word=%s"
	  euc-japan))
      '(add-to-list
	'w3m-uri-replace-alist
	'("\\`wdic:" w3m-search-uri-replace "wdic"))))

  (when (and
	 (require 'mime-view nil t)
	 (require 'mime-w3m nil t))
    (eval-after-load "mime-view"
      '(progn
	 (ctree-set-calist-strictly
	  'mime-preview-condition
	  '((type . text)
	    (subtype . html)
	    (body . visible)
	    (body-presentation-method . mime-w3m-preview-text/html)))
	 (set-alist 'mime-view-type-subtype-score-alist
		    '(text . html) 3))))

  (when (featurep 'meadow)
    (setq w3m-command "c:/cygwin/opt/w3m-0.5.1/bin/w3m.exe")
    (setq w3m-imagick-convert-program
	  "c:/Program Files/ImageMagick-6.2.1-Q16/convert.exe")))