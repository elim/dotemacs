;; -*- emacs-lisp -*-
;; $Id$

;; XWindow System
(eval-safe
 (progn
   (set-face-font 'default
		  "-shinonome-gothic-medium-r-normal--14-0-0-0-c-0-*-*")
   (set-face-font 'bold
		  "-shinonome-gothic-bold-r-normal--14-0-0-0-c-0-*-*")
   (set-face-font 'bold-italic
		  "-shinonome-gothic-bold-i-normal--14-0-0-0-c-0-*-*")))

;; Meadow 2.x
;; http://www4.kcn.ne.jp/%7Eboochang/emacs/meadow2-setup.html#font-setup
(defconst private-bdf-font-dir "c:/cygwin/home/takeru/lib/X11/fonts/shinonome")

(eval-safe
 (w32-add-font
  "shinonome 14"
  '((strict-spec
     ((:char-spec ascii :height any)
      (bdf-font ,(expand-file-name "shnm7x14r.bdf" private-bdf-font-dir)))
     ((:char-spec ascii :height any :weight bold)
      (bdf-font ,(expand-file-name "shnm7x14rb.bdf" private-bdf-font-dir)))
     ((:char-spec ascii :height any :slant italic)
      (bdf-font ,(expand-file-name "shnm7x14ri.bdf" private-bdf-font-dir)))
     ((:char-spec ascii :height any :weight  bold :slant italic)
     (bdf-font ,(expand-file-name "shnm7x14rbi.bdf" private-bdf-font-dir)))
     ((:char-spec japanese-jisx0208 :height any)
      (bdf-font ,(expand-file-name "shnmk14.bdf" private-bdf-font-dir)))
     ((:char-spec japanese-jisx0208 :height any :weight bold)
      (bdf-font ,(expand-file-name "shnmk14b.bdf" private-bdf-font-dir)))
     ((:char-spec japanese-jisx0208 :height any :slant italic)
      (bdf-font ,(expand-file-name "shnmk14i.bdf" private-bdf-font-dir)))
     ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
      (bdf-font ,(expand-file-name "shnmk14bi.bdf" private-bdf-font-dir)))))))

 (set-default-font "shinonome 14"))
