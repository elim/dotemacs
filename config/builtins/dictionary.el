;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (eq system-type 'darwin)
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

  (bind-keys :map global-map
    ("C-x e" . dictionary-word)
    ("C-x y" . dictionary-region)))
