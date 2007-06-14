;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 '("default"
   (wl-smtp-posting-server . my-wl-server-name)
   (wl-smtp-posting-port . my-smtp-posting-port)
   (wl-smtp-authenticate-type . "cram-md5")
   (wl-smtp-posting-user . "takeru")
   (wl-from . "Takeru Naito <takeru.naito@gmail.com>")
   (wl-fcc . "%Sent")
   (wl-organization . nil)
   ("From" . wl-from)
   ("Fcc" . wl-fcc)
   ("Organization" . wl-organization)
   (signature-file-name . (expand-file-name
			   (concat my-wl-signature-path "/" "default")))))