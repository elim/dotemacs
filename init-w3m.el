; -*- emcs-lisp -*-
; $Id$

(setq w3m-tab-width 4)
(setq w3m-use-cookies t)
(setq w3m-use-toolbar t)
(setq w3m-home-page "http://localhost/%7Etakeru/antenna/index.html")
(setq w3m-weather-default-area "道央・石狩")

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




