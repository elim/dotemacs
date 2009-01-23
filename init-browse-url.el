;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'browse-url nil t)
  (global-set-key "\C-xm" 'browse-url-at-point)

  (setq browse-url-browser-display t
        browse-url-new-window-flag nil)

  ;; http://cgi.netlaputa.ne.jp/~kose/diary/?200209b&to=200209125#200209125
  (defadvice thing-at-point-url-at-point
    (after thing-at-point-url-at-point-after activate)
    "http://ttp:// to http://"
    (setq ad-return-value
          (if (string-match "http://ttp:\\(.*\\)" ad-return-value)
              (concat "http:" (substring ad-return-value
                                         (match-beginning 1) (match-end 1)))
            ad-return-value))))