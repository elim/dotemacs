;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when darwin-p
  (defun dictionary-search (word)
    (browse-url
     (concat "dict:///" (url-hexify-string word))))

  (defun dictionary-word ()
    (interactive)
    (dictionary-search
     (substring-no-properties (thing-at-point 'word))))

  (defun dictionary-region (beg end)
    (interactive "r")
    (dictionary-search
     (buffer-substring-no-properties beg end)))

  (define-key ctl-x-map "e" 'dictionary-word)
  (define-key ctl-x-map "y" 'dictionary-region))