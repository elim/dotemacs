;-*- emcs-lisp -*-
; $Id: init-ddskk.el 69 2004-12-06 13:36:24Z takeru $

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
(set-default-font "BDF M+")
