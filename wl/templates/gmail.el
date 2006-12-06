;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 '("gmail"
   (wl-smtp-posting-server . "smtp.gmail.com")
   (wl-smtp-posting-user . "takeru.naito@gmail.com")
   (wl-smtp-connection-type . "starttls")
   (wl-smtp-posting-port . 587)
   (wl-smtp-authenticate-type . "plain")
   (wl-from . "Takeru Naito <takeru.naito@gmail.com>")
   ("From" . wl-from)
   (signature-file-name . (expand-file-name
			   (concat my-wl-signature-path "/gmail")))))
