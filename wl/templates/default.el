;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 `(,(file-name-sans-extension
    (file-name-nondirectory load-file-name))
   (wl-smtp-posting-server . "localhost")
   (wl-smtp-posting-port . 25)
   (wl-draft-send-mail-function . 'wl-draft-send-mail-with-smtp)
   (wl-smtp-authenticate-type . "cram-md5")
   (wl-smtp-posting-user . "takeru")
   (wl-local-domain . "elim.teroknor.org")
   ("From" . "Takeru Naito <takeru.naito@gmail.com>")
   ("Fcc" . "%Sent")
   ("Organization" . nil)))