;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(defun elim:set-default-frame-font (fontname)
  (setq  default-frame-alist (append
                              `((font . ,fontname))
         default-frame-alist)))

(cond
 ;; X Window System
 ((eq window-system 'x)
  (cond
   ;; emacs23
   ((= 23 emacs-major-version)
    (set-default-font "Bitstream Vera Sans Mono-9")
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0208
                      '("VL Gothic" . "unicode-bmp")))
   ;; emacs22
   ((x-list-fonts "*shinonome-gothic*")
    (create-fontset-from-fontset-spec
     "-shinonome-gothic-medium-r-*--12-*-*-*-*-*-fontset-shinonome12" nil t)
    (create-fontset-from-fontset-spec
     "-shinonome-gothic-medium-r-*--14-*-*-*-*-*-fontset-shinonome14" nil t)
    (set-default-font "fontset-shinonome14")

    (condition-case err
        (progn
          (set-face-font
           'default
           "-shinonome-gothic-medium-r-normal--12-0-0-0-c-0-*-*")
          (set-face-font
           'bold
           "-shinonome-gothic-bold-r-normal--12-0-0-0-c-0-*-*")
          (set-face-font
           'bold-italic
           "-shinonome-gothic-bold-i-normal--12-0-0-0-c-0-*-*"))
      (error (princ err))))))

 ;; Meadow 2.x or greater
 ((functionp 'w32-list-font)
  (not (w32-list-fonts "shinonome 14"))

  (let
      ((w32-font-path
        (expand-file-name "lib/X11/fonts/shinonome/"
                          (getenv "HOME"))))
    (when (file-accessible-directory-p w32-font-path)
      (w32-add-font
       "shinonome 14"
       `((strict-spec
          ((:char-spec ascii :height any)
           (bdf-font
            ,(expand-file-name "shnm7x14r.bdf" w32-font-path)))
          ((:char-spec ascii :height any :weight bold)
           (bdf-font
            ,(expand-file-name "shnm7x14rb.bdf" w32-font-path)))
          ((:char-spec ascii :height any :slant italic)
           (bdf-font
            ,(expand-file-name "shnm7x14ri.bdf" w32-font-path)))
          ((:char-spec ascii :height any :weight  bold :slant italic)
           (bdf-font
            ,(expand-file-name "shnm7x14rbi.bdf" w32-font-path)))
          ((:char-spec japanese-jisx0208 :height any)
           (bdf-font
            ,(expand-file-name "shnmk14.bdf" w32-font-path)))
          ((:char-spec japanese-jisx0208 :height any :weight bold)
           (bdf-font
            ,(expand-file-name "shnmk14b.bdf" w32-font-path)))
          ((:char-spec japanese-jisx0208 :height any :slant italic)
           (bdf-font
            ,(expand-file-name "shnmk14i.bdf" w32-font-path)))
          ((:char-spec japanese-jisx0208 :height any :weight bold :slant italic)
           (bdf-font
            ,(expand-file-name "shnmk14bi.bdf" w32-font-path))))))

      (set-default-font "shinonome 14")
      (add-to-list
       'default-frame-alist
       '(font . "shinonome 14")))))

 ;; NTEmacs
 ;; http://ntemacsjp.sourceforge.jp/matsuan/FontSettingJp.html
 (nt-p
   (setq w32-enable-synthesized-fonts t
         w32-use-w32-font-dialog t)

  (cond
   ;; emacs23
   ((<= 23 emacs-major-version)
    (elim:set-default-frame-font "ＭＳ ゴシック-10")
    (set-fontset-font (frame-parameter nil 'font)
                      'japanese-jisx0208
                      '("ＭＳ ゴシック" . "unicode-bmp")))

    (t
     (set-face-attribute 'default nil
                         :family "ＭＳ ゴシック"
                         :height 100)

     (set-fontset-font "fontset-default"
                       'japanese-jisx0208
                       '("ＭＳ ゴシック*" . "jisx0208-sjis"))

     (set-fontset-font "fontset-default"
                       'katakana-jisx0201
                       '("ＭＳ ゴシック*" . "jisx0201-katakana"))

     (add-to-list 'face-font-rescale-alist
                  `(,(encode-coding-string
                      ".*ＭＳ.*bold.*iso8859.*" 'emacs-mule) . 0.9))

     (add-to-list 'face-font-rescale-alist
                  `(,(encode-coding-string
                      ".*ＭＳ.*bold.*jisx02.*" 'emacs-mule) . 0.95)))))

  ;; Carbon Emacs
  (carbon-p
    (require 'carbon-font nil t)
    (add-to-list
     'default-frame-alist
     '(font . "-*-*-medium-r-normal--12-*-*-*-*-*-fontset-osaka"))
    (setq mac-allow-anti-aliasing nil))

  ;; Cocoa Emacs
  (ns-p
   (elim:set-default-frame-font "Osaka mono-12")

   (set-fontset-font
    "fontset-default"
    'japanese-jisx0208
    '("Osaka" . "iso10646-1"))
   (setq face-font-rescale-alist
         '(("^-apple-hiragino.*" . 1.2)
           (".*osaka-bold.*" . 1.2)
           (".*osaka-medium.*" . 1.2)
           (".*courier-bold-.*-mac-roman" . 1.0)
           (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
           (".*monaco-bold-.*-mac-roman" . 0.9)
           ("-cdac$" . 1.3)))))
