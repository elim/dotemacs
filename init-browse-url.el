;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'browse-url nil t)
  (global-set-key "\C-xm" 'browse-url-at-point)

  (setq browse-url-browser-display t
        browse-url-new-window-flag nil
        browse-url-browser-function 'browse-url-generic)
  (cond
   (windows-p
    (cond
     ((executable-find "cygstart")
      (setq browse-url-generic-program "cygstart"
            browse-url-generic-args '("--open")))
     ((executable-find "cmd")
      (setq browse-url-generic-program "cmd"
            browse-url-generic-args '("/c" "start")))))

   (darwin-p
    (setq browse-url-generic-program "open"))

   (window-system
    (setq browse-url-generic-program
          (fold-left (lambda (x y)
                       (or x (executable-find y)))
                     nil (list "x-www-browser"
                               "firefox"))))
   ((functionp #'w3m-browse-url)
    (setq browse-url-browser-function #'w3m-browse-url)))


  ;; http://cgi.netlaputa.ne.jp/~kose/diary/?200209b&to=200209125#200209125
  (defadvice thing-at-point-url-at-point
    (after thing-at-point-url-at-point-after activate)
    "http://ttp:// to http://"
    (setq ad-return-value
          (if (string-match "http://ttp:\\(.*\\)" ad-return-value)
              (concat "http:" (substring ad-return-value
                                         (match-beginning 1) (match-end 1)))
            ad-return-value))))