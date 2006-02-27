;; -*- emacs-lisp -*-
;; $Id$

;; X Window System
(when (and (eq window-system 'x) (x-list-fonts "*shinonome*"))
  (progn
    (set-face-font 'default
		   "-shinonome-gothic-medium-r-normal--14-0-0-0-c-0-*-*")
    (set-face-font 'bold
		   "-shinonome-gothic-bold-r-normal--14-0-0-0-c-0-*-*")
    (set-face-font 'bold-italic
		    "-shinonome-gothic-bold-i-normal--14-0-0-0-c-0-*-*")))

;; Meadow 2.x
(when (functionp 'w32-add-font)
  (w32-add-font
   "shinonome 14"
   '((strict-spec
      ((:char-spec ascii :height any)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14r.bdf"))
      ((:char-spec ascii :height any :weight bold)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14rb.bdf"))
      ((:char-spec ascii :height any :slant italic)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14ri.bdf"))
      ((:char-spec ascii :height any :weight  bold :slant italic)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnm7x14rbi.bdf"))
      ((:char-spec japanese-jisx0208 :height any)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14.bdf"))
      ((:char-spec japanese-jisx0208 :height any :weight bold)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14b.bdf"))
      ((:char-spec japanese-jisx0208 :height any :slant italic)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14i.bdf"))
      ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
       (bdf-font
	"c:/cygwin/home/takeru/lib/X11/fonts/shinonome/shnmk14bi.bdf")))))
  (set-default-font "shinonome 14")
  (add-to-list
   'default-frame-alist
   '(font . "shinonome 14")))

;; Carbon Emacs

(when (and (eq window-system 'mac) (locate-library "carbon-font"))
  (require 'carbon-font nil t)
  (add-to-list
   'initial-frame-alist
   '(font . "fontset-osaka"))
  (add-to-list
   'default-frame-alist
   '(font . "fontset-osaka")))
;;   '(font . "fontset-hiraginomaru")))
;;   '(font . "-*-*-medium-r-normal--10-*-*-*-*-*-fontset-hiraginomaru")))
