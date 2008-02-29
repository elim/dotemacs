;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; X Window System
(when (and (eq window-system 'x) (x-list-fonts "*shinonome-gothic*"))
  (progn
    (create-fontset-from-fontset-spec
     "-shinonome-gothic-medium-r-*--12-*-*-*-*-*-fontset-shinonome12" nil t)
    (create-fontset-from-fontset-spec
     "-shinonome-gothic-medium-r-*--14-*-*-*-*-*-fontset-shinonome14" nil t)

    (set-default-font "fontset-shinonome14"))

  (condition-case err
      (progn
	(set-face-font 'default
		       "-shinonome-gothic-medium-r-normal--14-0-0-0-c-0-*-*")
	(set-face-font 'bold
		       "-shinonome-gothic-bold-r-normal--14-0-0-0-c-0-*-*")
	(set-face-font 'bold-italic
		       "-shinonome-gothic-bold-i-normal--14-0-0-0-c-0-*-*"))
    (error (princ err))))

;; Meadow 2.x or greater
(setq my-w32-font-path
      (expand-file-name "lib/X11/fonts/shinonome/" (getenv "HOME")))
(when (and (functionp 'w32-add-font)
	   (file-accessible-directory-p my-w32-font-path))
  (when (not (w32-list-fonts "shinonome 14"))
    (w32-add-font
     "shinonome 14"
     `((strict-spec
	((:char-spec ascii :height any)
	 (bdf-font
	  ,(expand-file-name "shnm7x14r.bdf" my-w32-font-path)))
	((:char-spec ascii :height any :weight bold)
	 (bdf-font
	  ,(expand-file-name "shnm7x14rb.bdf" my-w32-font-path)))
	((:char-spec ascii :height any :slant italic)
	 (bdf-font
	  ,(expand-file-name "shnm7x14ri.bdf" my-w32-font-path)))
	((:char-spec ascii :height any :weight  bold :slant italic)
	 (bdf-font
	  ,(expand-file-name "shnm7x14rbi.bdf" my-w32-font-path)))
	((:char-spec japanese-jisx0208 :height any)
	 (bdf-font
	  ,(expand-file-name "shnmk14.bdf" my-w32-font-path)))
	((:char-spec japanese-jisx0208 :height any :weight bold)
	 (bdf-font
	  ,(expand-file-name "shnmk14b.bdf" my-w32-font-path)))
	((:char-spec japanese-jisx0208 :height any :slant italic)
	 (bdf-font
	  ,(expand-file-name "shnmk14i.bdf" my-w32-font-path)))
	((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
	 (bdf-font
	  ,(expand-file-name "shnmk14bi.bdf" my-w32-font-path)))))))

  (set-default-font "shinonome 14")
  (add-to-list
   'default-frame-alist
   '(font . "shinonome 14")))

;; Carbon Emacs
(when (and (eq window-system 'mac)
	   (require 'carbon-font nil t))
  (setq mac-allow-anti-aliasing nil)
  (add-to-list
   'default-frame-alist
   '(font . "-*-*-medium-r-normal--12-*-*-*-*-*-fontset-osaka"))

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