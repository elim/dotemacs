; -*- emcs-lisp -*-
; $Id$

(setq w3m-tab-width 4)
(setq w3m-use-cookies t)
(setq w3m-use-toolbar t)
(setq w3m-home-page "http://localhost/%7Etakeru/antenna/index.html")
(setq w3m-weather-default-area "道央・石狩")

(load "w3m-wget")

(eval-after-load "w3m-search"
  '(progn
     (add-to-list
      'w3m-search-engine-alist
      '("goo ja"
	"http://dictionary.goo.ne.jp/search.php?MT=%s&jn.x=54&jn.y=6"
	euc-japan)
      '("goo ej"
	"http://dictionary.goo.ne.jp/search.php?MT=%s&ej.x=16&ej.y=16"
	euc-japan))
     (add-to-list
      'w3m-uri-replace-alist
      '("\\`ja:" w3m-search-uri-replace "goo ja")
      '("\\`ej:" w3m-search-uri-replace "goo ej"))))




