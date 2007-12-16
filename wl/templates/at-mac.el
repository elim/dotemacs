;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 `(,(file-name-sans-extension
     (file-name-nondirectory load-file-name))
   (wl-smtp-posting-server . "mail.at-mac.com")
   (wl-smtp-posting-port . 25)
   (wl-smtp-authenticate-type . nil)
   (wl-smtp-connection-type . nil)
   (wl-local-domain . "at-mac.com")
   (wl-draft-send-mail-function . 'wl-draft-send-mail-with-pop-before-smtp)
   (wl-pop-before-smtp-user . "takeru")
   (wl-pop-before-smtp-server . "mail.at-mac.com")
   (wl-pop-before-smtp-authenticate-type . 'user)
   (wl-pop-before-smtp-port . 110)
   (wl-pop-before-smtp-stream-type . nil)
   ("From" . "Takeru Naito <takeru@at-mac.com>")
   ("Fcc" . "%Sent@mail.at-mac.com:143!direct")
   ("Organization" . "Century Corporation")))
