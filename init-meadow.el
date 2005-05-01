;-*- emcs-lisp -*-
; $Id$

(setq-default line-spacing 2)

(autoload 'riece "riece" nil t)
(require 'skk-setup)
(require 'w3m-load)
(require 'lookup)
(require 'skk)
(load "~/dot.files/.skk")

(w32-add-font
 "BDF M+"
 '((strict-spec
    ((:char-spec ascii :height any)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_f12r.bdf"))
    ((:char-spec ascii :height any :weight bold)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_f12b.bdf"))
    ((:char-spec ascii :height any :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_f12i.bdf"))
    ((:char-spec ascii :height any :weight  bold :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_f12bi.bdf"))
    ((:char-spec japanese-jisx0208 :height any)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_j12r.bdf"))
    ((:char-spec japanese-jisx0208 :height any :weight bold)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_j12b.bdf"))
    ((:char-spec japanese-jisx0208 :height any :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_j12i.bdf"))
    ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/mplus_j12bi.bdf")))))


(w32-add-font
 "shinonome 14"
 '((strict-spec
    ((:char-spec ascii :height any)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14r.bdf"))
    ((:char-spec ascii :height any :weight bold)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14rb.bdf"))
    ((:char-spec ascii :height any :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14ri.bdf"))
    ((:char-spec ascii :height any :weight  bold :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14rbi.bdf"))
    ((:char-spec japanese-jisx0208 :height any)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14.bdf"))
    ((:char-spec japanese-jisx0208 :height any :weight bold)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14b.bdf"))
    ((:char-spec japanese-jisx0208 :height any :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14i.bdf"))
    ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
     (bdf-font "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14bi.bdf")))))

(set-default-font "shinonome 14")
