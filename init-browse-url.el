;; -*- emacs-lisp -*-
;; $Id$

(when (require 'browse-url)
  (global-set-key [(hyper m)] 'browse-url-at-point)
  (global-set-key "\C-xm" 'browse-url-at-point)
  (setq browse-url-browser-display nil)
  (setq browse-url-browser-function 'browse-url-generic)
  (setq browse-url-new-window-flag nil)
  (setq browse-url-generic-program
	(cond
	 ((featurep 'meadow)
	  "c:/Program Files/Mozilla Firefox/firefox.exe")
	 ((featurep 'carbon-emacs-package)
	  "open")
	 (t
	  "~/bin/firefox"))))

;; http://cgi.netlaputa.ne.jp/~kose/diary/?200209b&to=200209125#200209125
(defadvice thing-at-point-url-at-point
  (after thing-at-point-url-at-point-after activate)
  "http://ttp:// to http://"
  (setq ad-return-value
	(if (string-match "http://ttp:\\(.*\\)" ad-return-value)
	    (concat "http:" (substring ad-return-value
				       (match-beginning 1) (match-end 1)))
	  ad-return-value)))
