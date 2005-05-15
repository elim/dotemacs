; -*- emcs-lisp -*-
; $Id$

(autoload 'w3m "w3m" "*Interface for w3m on Emacs." t)
(autoload 'w3m-find-file "w3m" "*w3m interface function for local file." t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(autoload 'w3m-search "w3m-search" "*Search QUERY using SEARCH-ENGINE." t)
(autoload 'w3m-weather "w3m-weather" "*Display weather report." t)
(autoload 'w3m-antenna "w3m-antenna" "*Report chenge of WEB sites." t)

(setq w3m-pop-up-frames t)
(setq w3m-tab-width 4)
1(setq w3m-use-cookies t)
(setq w3m-use-toolbar t)
(setq w3m-home-page "http://elim.teroknor.org/%7Etakeru/pukiwiki/")
(setq w3m-weather-default-area "$BF;1{!&@P<m(B")

(if (featurep 'meadow)
    (progn(setq w3m-command "c:/cygwin/opt/w3m-0.5.1/bin/w3m.exe")
	  (setq w3m-imagick-convert-program
	   "c:/Program Files/ImageMagick-6.2.1-Q16/convert.exe"))
  nil)

(global-set-key "\C-cs" 'w3m-search)
;(load "w3m-wget")


(eval-after-load "w3m-search"
  '(progn
     (add-to-list
      'w3m-search-engine-alist
      '("wdic"
	"http://www.wdic.org/?word=%s"
	euc-japan))
     (add-to-list
      'w3m-uri-replace-alist
      '("\\`wdic:" w3m-search-uri-replace "wdic"))))




