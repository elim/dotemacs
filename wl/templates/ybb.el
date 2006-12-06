;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(add-to-list
 'wl-template-alist
 '("Yahoo! BB"
   (wl-smtp-posting-server . "ybbsmtp.mail.yahoo.co.jp")
   (wl-smtp-posting-port . 25)
   (wl-smtp-authenticate-type . "plain")
   (wl-smtp-posting-user . "fascinating_logic")
   (wl-from . "Takeru Naito <fascinating_logic@ybb.ne.jp>")
   ("From" . wl-from)
   (signature-file-name . (expand-file-name
			   (concat my-wl-signature-path "/" "ybb")))))
