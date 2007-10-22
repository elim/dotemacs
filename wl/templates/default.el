;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 `(,(file-name-sans-extension
    (file-name-nondirectory load-file-name))
   (wl-smtp-posting-server
    .
    (if (domestic-network-member-p) "idea" "localhost"))
   (wl-smtp-posting-port
    .
    (if (domestic-network-member-p) 25 10025))
   (wl-smtp-authenticate-type . "cram-md5")
   (wl-smtp-posting-user . "takeru")
   (wl-local-domain . "elim.teroknor.org")
   (wl-from . "Takeru Naito <takeru.naito@gmail.com>")
   (wl-fcc . "%Sent")
   (wl-organization . nil)
   ("From" . wl-from)
   ("Fcc" . wl-fcc)
   ("Organization" . wl-organization)))