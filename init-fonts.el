;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
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
  (when (require 'carbon-font nil t)
    (setq mac-allow-anti-aliasing nil)
    (add-to-list
     'default-frame-alist
     '(font . "-*-*-medium-r-normal--12-*-*-*-*-*-fontset-hiraginokaku"))))

;;     (if (x-list-fonts "*sazanami*")
;; 	(progn
;; 	  (setq-default line-spacing 6)
;; 	  (setq carbon-font-encode-family-list-sazanami
;; 		'((ascii . "sazanami gothic")
;; 		  (japanese-jisx0208 . "sazanami gothic")
;; 		  (katakana-j2222isx0201 . "sazanami gothic")
;; 		  (thai-tis620 . "ayuthaya")
;; 		  (chinese-gb2312 . "stheiti*")
;; 		  (chinese-big5-1 . "lihei pro*")
;; 		  (korean-ksc5601 . "applegothic*")))
;; 	  (carbon-font-create-fontset "sazanami"
;; 				      carbon-font-defined-sizes
;; 				      carbon-font-encode-family-list-sazanami)
;; 	  (add-to-list
;; 	   'default-frame-alist
;; 	   '(font . "-*-*-medium-r-normal--14-*-*-*-*-*-fontset-sazanami")))
;;       (progn
;; 	(setq-default line-spacing 2)
;; 	(setq mac-allow-anti-aliasing t)
;; 	(add-to-list
;; 	 'default-frame-alist
;; 	 '(font . "-*-*-medium-r-normal--14-*-*-*-*-*-fontset-hiraginokaku"))))))
