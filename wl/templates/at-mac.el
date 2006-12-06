;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 '("at-mac"
   (wl-smtp-posting-server . my-wl-server-name)
   (wl-smtp-posting-port . my-smtp-posting-port)
   (wl-from . "Takeru Naito <takeru@at-mac.com>")
   ("From" . wl-from)
   (signature-file-name . (expand-file-name
			   (concat my-wl-signature-path "/at-mac")))
   (skk-kutouten-type . 'jp)))