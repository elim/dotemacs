;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; X Window System
(when (and (eq window-system 'x) (x-list-fonts "*shinonome-gothic*"))
  (progn
    (set-face-font 'default
		   "-shinonome-gothic-medium-r-normal--14-0-0-0-c-0-*-*")
    (set-face-font 'bold
		   "-shinonome-gothic-bold-r-normal--14-0-0-0-c-0-*-*")
    (set-face-font 'bold-italic
		    "-shinonome-gothic-bold-i-normal--14-0-0-0-c-0-*-*")))

;; Meadow 2.x or greater
(setq my-w32-font-path "c:/cygwin/home/takeru/lib/X11/fonts/shinonome/")
(when (and (functionp 'w32-add-font)
	   (file-accessible-directory-p my-w32-font-path))
  (w32-add-font
   "shinonome 14"
   `((strict-spec
      ((:char-spec ascii :height any)
       (bdf-font
	,(concat my-w32-font-path "shnm7x14r.bdf")))
      ((:char-spec ascii :height any :weight bold)
       (bdf-font
	,(concat my-w32-font-path "shnm7x14rb.bdf")))
      ((:char-spec ascii :height any :slant italic)
       (bdf-font
	,(concat my-w32-font-path "shnm7x14ri.bdf")))
      ((:char-spec ascii :height any :weight  bold :slant italic)
       (bdf-font
	,(concat my-w32-font-path "shnm7x14rbi.bdf")))
      ((:char-spec japanese-jisx0208 :height any)
       (bdf-font
	,(concat my-w32-font-path "shnmk14.bdf")))
      ((:char-spec japanese-jisx0208 :height any :weight bold)
       (bdf-font
	,(concat my-w32-font-path "shnmk14b.bdf")))
      ((:char-spec japanese-jisx0208 :height any :slant italic)
       (bdf-font
	,(concat my-w32-font-path "shnmk14i.bdf")))
      ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
       (bdf-font
	,(concat my-w32-font-path "shnmk14bi.bdf"))))))

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
     '(font . "-*-*-medium-r-normal--12-*-*-*-*-*-fontset-osaka")))

  (when (x-list-fonts "*vl gothic*")
    (setq carbon-font-encode-family-list-vl
	  '((ascii . "monaco")
	    (japanese-jisx0208 . "vl gothic")
	    (katakana-jisx0201 . "vl gothic")
	    (thai-tis620 . "ayuthaya")
	    (chinese-gb2312 . "stheiti*")
	    (chinese-big5-1 . "lihei pro*")
	    (korean-ksc5601 . "applegothic*")))

    (carbon-font-create-fontset "vl"
				carbon-font-defined-sizes
				carbon-font-encode-family-list-vl)))