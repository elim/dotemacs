;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (and (or
	    (featurep 'mac-carbon)
	    (featurep 'meadow)
	    (locate-executable "www-browser")
	    (locate-executable "firefox")
       (require 'browse-url nil t))

  (global-set-key "\C-xm" 'browse-url-at-point)

  (if window-system
      (progn
	(setq browse-url-browser-function
	      'browse-url-generic)
	(cond
	 ((locate-executable "firefox")
	  (setq browse-url-generic-program "firefox"))
	 ((locate-executable "cmd")
	  (setq browse-url-generic-program "cmd"
		browse-url-generic-args "\/cstart"))
	 ((locate-executable "open")
	  (setq browse-url-generic-program "open"))))
    (progn
      (when (functionp 'w3m-browse-url)
	(setq browse-url-browser-function
	      'w3m-browse-url)))))

  (setq browse-url-browser-display t)
  (setq browse-url-new-window-flag nil))


;; http://cgi.netlaputa.ne.jp/~kose/diary/?200209b&to=200209125#200209125
(defadvice thing-at-point-url-at-point
  (after thing-at-point-url-at-point-after activate)
  "http://ttp:// to http://"
  (setq ad-return-value
	(if (string-match "http://ttp:\\(.*\\)" ad-return-value)
	    (concat "http:" (substring ad-return-value
				       (match-beginning 1) (match-end 1)))
	  ad-return-value)))