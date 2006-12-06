;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 '("terok nor"
   (wl-smtp-posting-server . my-wl-server-name)
   (wl-smtp-posting-port . my-smtp-posting-port)
   (wl-smtp-authenticate-type . "cram-md5")
   (wl-smtp-posting-user . "takeru")
   (wl-from . "elim garak <elim@teroknor.org>")
   ("From" . wl-from)
   (signature-file-name . (expand-file-name
			   (concat my-wl-signature-path "/" "teroknor")))))