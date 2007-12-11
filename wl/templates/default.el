;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 `(,(file-name-sans-extension
    (file-name-nondirectory load-file-name))
   (smtp-open-connection-function . #'open-ssh-stream-idea)
   (wl-smtp-posting-server . "localhost")
   (wl-smtp-posting-port . 25)
   (wl-draft-send-mail-function . 'wl-draft-send-mail-with-smtp)
   (wl-smtp-authenticate-type . "cram-md5")
   (wl-smtp-posting-user . "takeru")
   (wl-local-domain . "elim.teroknor.org")
   (wl-from . "Takeru Naito <takeru.naito@gmail.com>")
   (wl-fcc . "%Sent")
   (wl-organization . nil)
   ("From" . wl-from)
   ("Fcc" . wl-fcc)
   ("Organization" . wl-organization)))