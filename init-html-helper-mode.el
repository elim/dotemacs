;-*- emcs-lisp -*-
; $Id$
(add-hook 'html-helper-mode-hook
	  '(lambda () (set-file-coding-system *euc-jp-unix*)))

(setq html-helper-do-write-file-hooks   t
      html-helper-build-new-buffer      nil
      html-helper-basic-offset          1
      html-helper-item-continue-indent  2
      html-helper-address-string        "elim@teroknor.org")

(setq html-helper-new-buffer-template
      '("<?xml version=\"1.0\" encoding=\"EUC-JP\"?>\n"
	"<!DOCTYPE html"
	"PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"\n"
	"\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n"
	"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ja\">\n"
	"<head>"
	"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=EUC-JP\" />\n"
	"<meta http-equiv=\"Content-Style-Type\" content=\"text/css\" />\n"
	"<meta http-equiv=\"Content-Script-Type\" content=\"application/x-javascript\" />\n"
	"<meta name=\"author\" content=\"Elim Garak\" />\n"
	"<meta name=\"Description\" content=\"\" />\n"
	"<meta name=\"Keywords\" content=\"\" />\n"
	"<title></title>\n"
	"<link rel=\"stylesheet\" href=\"Style.css\" media=\"screen\" />\n"
	"<link rel=\"contents\" href=\"index.html\" title=\"top page\" />\n"
	"<link rel=\"icon\" href=\"Images/favicon.png\" type=\"image/png\">\n"
	"<link rev=\"made\" href=\"mailto:elim&#64;teroknor.org\" />\n"
	"</head>\n"
	"<body>\n"
	"<div id=\"main-container\"> \n"
	"<h1></h1>\n"
	"<address>\n"
	 "&copy; 2004 <a href=\"mailto:elim&#64;teroknor.org\">Elim</a>\n"
	 "</address>\n"
	 "</div>\n"
	 "</body>\n"
	 "</html>\n"
	 )
      )

