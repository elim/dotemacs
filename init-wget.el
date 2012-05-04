;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload
       'wget "wget" "wget interface for Emacs." t)
  (autoload
   'wget-web-page "wget" "wget interface to download whole web page." t)

  (setq wget-download-directory
        (expand-file-name "~/Downloads")))
