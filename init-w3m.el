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

  (setq w3m-pop-up-frames nil)
  (setq w3m-tab-width 4)
  (setq w3m-use-cookies t)
  (setq w3m-use-tab t)
  (setq w3m-use-toolbar t)
  (setq w3m-home-page "about:blank")
  (setq w3m-weather-default-area "道央・石狩")

  (global-set-key "\C-cs" 'w3m-search)

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
		    '(text . html) 3)))))


;; http://ko.meadowy.net/%7Eshirai/diary/20070223.html#p01
(setq w3m-use-filter t)
(setq w3m-filter-rules
      `(("\\`https?://\\(www.\\)?amazon\\.co\\.jp/.+" w3m-filter-amazon)))

(defun w3m-filter-amazon (url)
  (when (and url
	     (or (string-match
		  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/exec/obidos/ASIN/\\([0-9]+\\)"
		  url)
		 (string-match
		  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/o/ASIN/\\([0-9]+\\)"
		  url)
		 (string-match
		  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/gp/product/\\([0-9]+\\)"
		  url)
		 (string-match
		  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/\\(?:[^/]+/\\)?dp/\\([0-9]+\\)"
		  url)))
    (let* ((base (match-string 1 url))
	   (asin (match-string 2 url))
	   (shorturls `(,(concat base "/dp/" asin "/")
			,(concat base "/o/ASIN/" asin "/")
			,(concat base "/gp/product/" asin "/")))
	   (case-fold-search t)
	   shorturl)
      (goto-char (point-min))
      (setq url (file-name-as-directory url))
      (when (search-forward "<body>" nil t)
	(insert "\n")
	(while (setq shorturl (car shorturls))
	  (setq shorturls (cdr shorturls))
	  (unless (string= url shorturl)
	    (insert (format "Amazon Short URL: <a href=\"%s\">%s</a><br>\n"
			    shorturl shorturl))))
	(insert "\n")))))